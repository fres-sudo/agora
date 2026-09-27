import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_reports/data/mappers/closing_report_receipt_mapper.dart';
import 'package:feature_reports/domain/models/closing_report.dart';
import 'package:feature_reports/presentation/blocs/closing_report/closing_report_cubit.dart';
import 'package:feature_reports/presentation/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ClosingReportPage extends StatefulWidget {
  const ClosingReportPage({super.key});

  @override
  State<ClosingReportPage> createState() => _ClosingReportPageState();
}

class _ClosingReportPageState extends State<ClosingReportPage> {
  final _cashController = TextEditingController();
  final _notesController = TextEditingController();

  static const _mobileBreakpoint = 600.0;
  static const _tabletBreakpoint = 900.0;

  @override
  void initState() {
    super.initState();
    context.closingReportCubit.load();
  }

  @override
  void dispose() {
    _cashController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClosingReportCubit, ClosingReportState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status == ClosingReportStatus.ready,
      listener: (context, state) {
        // Sync text fields to the freshly loaded report.
        final cents = state.currentReport?.cashCountedCents;
        _cashController.text =
            cents != null ? (cents / 100).toStringAsFixed(2) : '';
        _notesController.text = state.currentReport?.notes ?? '';
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AdaptiveAppBar.of(context, title: 'Chiusura di Cassa'),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ClosingReportState state) {
    if (state.isLoading && state.currentReport == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ClosingReportStatus.error &&
        state.currentReport == null) {
      return _buildError(context);
    }

    final report = state.currentReport;
    if (report == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < _mobileBreakpoint;
        final isTabletPortrait =
            width >= _mobileBreakpoint && width < _tabletBreakpoint;

        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isMobile
                ? context.tokens.spacing.sm
                : context.tokens.spacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state, isMobile),
              SizedBox(height: context.tokens.spacing.md),
              _buildPeriodRow(context, report),
              SizedBox(height: context.tokens.spacing.lg),
              _buildFinancialGrid(context, width, report, isMobile, isTabletPortrait),
              SizedBox(height: context.tokens.spacing.lg),
              _buildCashReconciliation(context, state, report),
              SizedBox(height: context.tokens.spacing.lg),
              _buildNotes(context),
              if (state.history.isNotEmpty) ...[
                SizedBox(height: context.tokens.spacing.xl),
                _buildHistory(context, state.history),
              ],
              SizedBox(height: context.tokens.spacing.xl),
            ],
          ),
        );
      },
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    ClosingReportState state,
    bool isMobile,
  ) {
    final isSaved = state.currentReport?.isSaved ?? false;
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrintButton(context, state),
        SizedBox(width: context.tokens.spacing.sm),
        _buildSaveButton(context, state, isSaved),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.tokens.spacing.xl),
          AppText.titleLg('Chiusura di Cassa'),
          SizedBox(height: context.tokens.spacing.sm),
          actions,
        ],
      );
    }

    return Row(
      children: [
        AppText.titleLg('Chiusura di Cassa'),
        const Spacer(),
        actions,
      ],
    );
  }

  Widget _buildPrintButton(BuildContext context, ClosingReportState state) {
    return AppButton.outline(
      onPressed: state.isReady ? () => _onPrint(context, state) : null,
      label: 'Stampa',
      leadingIcon: const Icon(AgoraIcons.printer, size: 20),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.colors.foreground,
        side: BorderSide(color: context.colors.border),
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spacing.md,
          vertical: context.tokens.spacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tokens.radius.xs),
        ),
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    ClosingReportState state,
    bool isSaved,
  ) {
    final label = isSaved ? 'Salvata' : 'Salva Chiusura';
    return AppButton.filled(
      onPressed: (!isSaved && state.isReady && !state.isSaving)
          ? () => _onSave(context)
          : null,
      label: state.isSaving ? 'Salvataggio…' : label,
      leadingIcon: Icon(
        isSaved ? AgoraIcons.check : AgoraIcons.save,
        size: 20,
      ),
    );
  }

  // ─── Period row ──────────────────────────────────────────────────────────────

  Widget _buildPeriodRow(BuildContext context, ClosingReport report) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spacing.md,
        vertical: context.tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: BorderRadius.circular(context.tokens.radius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AgoraIcons.calendar, size: 16, color: context.colors.mutedForeground),
          SizedBox(width: context.tokens.spacing.xs),
          AppText.bodySm(
            '${_fmtDateTime(report.periodStart)}  →  ${_fmtDateTime(report.periodEnd)}',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }

  // ─── Financial summary grid ───────────────────────────────────────────────────

  Widget _buildFinancialGrid(
    BuildContext context,
    double width,
    ClosingReport report,
    bool isMobile,
    bool isTabletPortrait,
  ) {
    final fmt = context.formatCurrency;
    final netRevenue = report.totalRevenueCents - report.totalTaxCents;

    final cards = [
      SummaryCard(
        title: 'Ordini completati',
        value: report.totalOrders.toString(),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.cart, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'Incasso lordo',
        value: fmt(report.totalRevenueCents),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.coin_alt, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'IVA inclusa',
        value: fmt(report.totalTaxCents),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.receipt, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'Sconti',
        value: fmt(report.totalDiscountCents),
        trend: '',
        isPositive: false,
        icon: Icon(AgoraIcons.tag, color: context.colors.destructive, size: 20),
      ),
      SummaryCard(
        title: 'Incasso netto',
        value: fmt(netRevenue),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.coin_alt, color: context.colors.success, size: 20),
      ),
      SummaryCard(
        title: 'Contanti',
        value: fmt(report.cashRevenueCents),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.wallet, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'Carta',
        value: fmt(report.cardRevenueCents),
        trend: '',
        isPositive: true,
        icon: Icon(AgoraIcons.credit_card, color: context.colors.primary, size: 20),
      ),
      SummaryCard(
        title: 'Ordini annullati',
        value: report.voidedOrders.toString(),
        trend: '',
        isPositive: report.voidedOrders == 0,
        icon: Icon(AgoraIcons.x_circle, color: context.colors.destructive, size: 20),
      ),
    ];

    final int crossAxisCount;
    final double childAspectRatio;

    if (isMobile) {
      crossAxisCount = 2;
      childAspectRatio = 1.6;
    } else if (isTabletPortrait) {
      crossAxisCount = 4;
      childAspectRatio = 1.4;
    } else {
      crossAxisCount = 4;
      childAspectRatio = 1.6;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.titleMd('Riepilogo Finanziario'),
        SizedBox(height: context.tokens.spacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: context.tokens.spacing.sm,
            mainAxisSpacing: context.tokens.spacing.sm,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) => cards[index],
        ),
      ],
    );
  }

  // ─── Cash reconciliation ─────────────────────────────────────────────────────

  Widget _buildCashReconciliation(
    BuildContext context,
    ClosingReportState state,
    ClosingReport report,
  ) {
    final variance = report.cashVarianceCents;
    final hasCashCount = report.cashCountedCents != null;
    final isPositiveVariance = variance >= 0;

    return Container(
      padding: EdgeInsets.all(context.tokens.spacing.md),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(context.tokens.radius.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMd('Riconciliazione Cassa'),
          SizedBox(height: context.tokens.spacing.md),
          _buildReconciliationRow(
            context,
            'Contanti attesi',
            context.formatCurrency(report.cashRevenueCents),
            color: context.colors.foreground,
          ),
          SizedBox(height: context.tokens.spacing.sm),
          Row(
            children: [
              Expanded(
                child: AppText.body(
                  'Contanti contati',
                  color: context.colors.mutedForeground,
                ),
              ),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _cashController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    prefixText: '${context.currencySymbol} ',
                    hintText: '0.00',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.tokens.spacing.sm,
                      vertical: context.tokens.spacing.xs,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.tokens.radius.xs),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                  ),
                  onChanged: (value) {
                    final euros = double.tryParse(value);
                    final cents = euros != null ? (euros * 100).round() : null;
                    context.closingReportCubit.setCashCounted(cents);
                  },
                ),
              ),
            ],
          ),
          if (hasCashCount) ...[
            SizedBox(height: context.tokens.spacing.sm),
            _buildReconciliationRow(
              context,
              'Differenza',
              '${variance >= 0 ? '+' : ''}${context.formatCurrency(variance)}',
              color: isPositiveVariance
                  ? context.colors.success
                  : context.colors.destructive,
              bold: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReconciliationRow(
    BuildContext context,
    String label,
    String value, {
    Color? color,
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppText.body(label, color: context.colors.mutedForeground),
        ),
        bold
            ? AppText.titleMd(value, color: color)
            : AppText.body(value, color: color),
      ],
    );
  }

  // ─── Notes ───────────────────────────────────────────────────────────────────

  Widget _buildNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.titleMd('Note (opzionale)'),
        SizedBox(height: context.tokens.spacing.sm),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Aggiungi una nota per questa chiusura…',
            contentPadding: EdgeInsets.all(context.tokens.spacing.sm),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.tokens.radius.xs),
              borderSide: BorderSide(color: context.colors.border),
            ),
          ),
          onChanged: (value) => context.closingReportCubit.setNotes(value),
        ),
      ],
    );
  }

  // ─── History ─────────────────────────────────────────────────────────────────

  Widget _buildHistory(BuildContext context, List<ClosingReport> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.titleMd('Chiusure precedenti'),
        SizedBox(height: context.tokens.spacing.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: context.tokens.spacing.xs),
          itemBuilder: (context, index) =>
              _ClosingReportHistoryItem(report: history[index]),
        ),
      ],
    );
  }

  // ─── Error ───────────────────────────────────────────────────────────────────

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AgoraIcons.alert_triangle, color: context.colors.destructive, size: 48),
          SizedBox(height: context.tokens.spacing.sm),
          const AppText.body('Impossibile caricare i dati.'),
          SizedBox(height: context.tokens.spacing.sm),
          AppButton.outline(
            onPressed: () => context.closingReportCubit.load(),
            label: 'Riprova',
          ),
        ],
      ),
    );
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────

  Future<void> _onPrint(BuildContext context, ClosingReportState state) async {
    final report = state.currentReport;
    if (report == null) return;

    final settings = context.read<SettingsCubit>();
    final config = buildReceiptConfig(settings);
    final receipt = report.toZReportReceipt(config);
    final printer = context.read<PrinterService>();

    try {
      final bytes = await const ReceiptRenderer().toEscPos(receipt);
      if (!context.mounted) return;
      final result = await printer.printBytes(bytes);
      if (!context.mounted) return;
      result.when(
        success: (_) => AppToast.success(context, message: 'Chiusura inviata alla stampante'),
        error: (e) => AppToast.error(
          context,
          message: 'Stampante non raggiungibile: ${e.message}',
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(context, message: 'Errore di stampa');
    }
  }

  Future<void> _onSave(BuildContext context) async {
    await context.closingReportCubit.save();
    if (!context.mounted) return;
    final state = context.read<ClosingReportCubit>().state;
    if (state.status == ClosingReportStatus.saved) {
      AppToast.success(context, message: 'Chiusura salvata');
    } else if (state.status == ClosingReportStatus.error) {
      AppToast.error(
        context,
        message: state.errorMessage ?? 'Impossibile salvare',
      );
    }
  }

  // ─── Formatting ──────────────────────────────────────────────────────────────

  static String _fmtDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$mi';
  }
}

// ─── History item ─────────────────────────────────────────────────────────────

class _ClosingReportHistoryItem extends StatelessWidget {
  const _ClosingReportHistoryItem({required this.report});
  final ClosingReport report;

  @override
  Widget build(BuildContext context) {
    final hasCashCount = report.cashCountedCents != null;
    final variance = report.cashVarianceCents;
    final isPositive = variance >= 0;

    return Container(
      padding: EdgeInsets.all(context.tokens.spacing.sm),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(context.tokens.radius.sm),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodySm(
                  _fmtDate(report.createdAt ?? report.periodEnd),
                  color: context.colors.mutedForeground,
                ),
                SizedBox(height: context.tokens.spacing.xxxs),
                AppText.body(
                  '${report.totalOrders} ordini · '
                  '${context.formatCurrency(report.totalRevenueCents)}',
                ),
                if (report.notes != null && report.notes!.isNotEmpty)
                  AppText.bodySm(
                    report.notes!,
                    color: context.colors.mutedForeground,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (hasCashCount) ...[
            SizedBox(width: context.tokens.spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText.label(
                  isPositive ? 'Avanzo' : 'Ammanchi',
                  color: isPositive
                      ? context.colors.success
                      : context.colors.destructive,
                ),
                AppText.titleMd(
                  '${variance >= 0 ? '+' : ''}${context.formatCurrency(variance)}',
                  color: isPositive
                      ? context.colors.success
                      : context.colors.destructive,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _fmtDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/${dt.year} $h:$mi';
  }
}
