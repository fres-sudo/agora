/// Agora Design System.
///
/// A hybrid, token-driven component library organized by atomic design:
/// atoms -> molecules -> organisms -> templates, sitting on a foundation of
/// semantic design tokens ([AppColors], [AppTypography], [AppTokens]) exposed
/// through `context.colors` / `context.typography` / `context.tokens`.
library;

// -- Foundation: design tokens & theme ---------------------------------------
export 'src/theme/app_palette.dart';
export 'src/theme/app_colors.dart';
export 'src/theme/app_typography.dart';
export 'src/theme/app_tokens.dart';
export 'src/theme/app_theme.dart';
export 'src/theme/agora_icons.dart';
export 'src/theme/context_extensions.dart';
export 'src/theme/cubits/theme_cubit.dart';

// -- Foundation: responsive & device utilities -------------------------------
export 'src/responsive/device.dart';
export 'src/responsive/responsive_scope.dart';
export 'src/responsive/adaptive_layout.dart';

// -- Foundation: bundled data --------------------------------------------------
export 'src/data/product_stock_gallery.dart';
export 'src/data/product_icon_catalog.dart';

// -- Atoms -------------------------------------------------------------------
export 'src/atoms/app_text.dart';
export 'src/atoms/app_button.dart';
export 'src/atoms/app_icon_button.dart';
export 'src/atoms/app_badge.dart';
export 'src/atoms/app_divider.dart';
export 'src/atoms/app_surface.dart';
export 'src/atoms/app_spinner.dart';
export 'src/atoms/app_switch.dart';
export 'src/atoms/app_checkbox.dart';
export 'src/atoms/app_chip.dart';
export 'src/atoms/app_avatar.dart';
export 'src/atoms/app_skeleton.dart';

// -- Molecules ---------------------------------------------------------------
export 'src/molecules/app_text_field.dart';
export 'src/molecules/app_alert.dart';
export 'src/molecules/app_card.dart';
export 'src/molecules/app_list_tile.dart';
export 'src/molecules/app_empty_state.dart';
export 'src/molecules/app_search_field.dart';
export 'src/molecules/app_segmented_control.dart';

// -- Overlays ------------------------------------------------------------
export 'src/overlays/app_select.dart';
export 'src/overlays/app_multi_select.dart';
export 'src/overlays/app_combobox.dart';
export 'src/overlays/app_creatable_combobox.dart';
export 'src/overlays/adaptive_modal.dart';
export 'src/overlays/app_sheet_scaffold.dart';
export 'src/overlays/app_persistent_sheet.dart';

// -- Organisms ---------------------------------------------------------------
export 'src/organisms/app_dialog.dart';
export 'src/organisms/app_app_bar.dart';
export 'src/organisms/adaptive_app_bar.dart';
export 'src/widgets/adaptive_sheet.dart';
export 'src/widgets/app_toast.dart';
export 'src/widgets/app_snack_bar.dart';
export 'src/widgets/app_shell/app_shell_module.dart';
export 'src/widgets/app_menu_drawer/app_menu_drawer.dart';
export 'src/widgets/app_menu_drawer/menu_drawer_item.dart';
export 'src/widgets/app_menu_drawer/menu_drawer_user_tile.dart';
export 'src/widgets/data_table/data_table.dart';
export 'src/widgets/data_table/data_table_column.dart';
export 'src/widgets/data_table/data_table_config.dart';
export 'src/widgets/data_table/data_table_controller.dart';
export 'src/widgets/data_table/data_table_delete_dialog.dart';
export 'src/widgets/data_table/data_table_empty_state.dart';
export 'src/widgets/data_table/data_table_filter_dialog.dart';
export 'src/widgets/data_table/data_table_header.dart';
export 'src/widgets/data_table/data_table_loading_state.dart';
export 'src/widgets/data_table/data_table_mobile_list.dart';
export 'src/widgets/data_table/data_table_pagination.dart';
export 'src/widgets/data_table/data_table_view.dart';
export 'src/widgets/money_keypad.dart';
export 'src/widgets/quantity_button.dart';
export 'src/widgets/app_sourced_image.dart';

// -- Templates ---------------------------------------------------------------
export 'src/templates/app_scaffold.dart';
export 'src/widgets/section_page_layout/section_page_layout.dart';
export 'src/widgets/section_page_layout/section_sidebar.dart';
export 'src/widgets/section_page_layout/section_sidebar_item.dart';
export 'src/widgets/section_page_layout/section_tab_bar.dart';
export 'src/widgets/section_page_layout/section_mobile_navigator.dart';

// -- Backwards-compat: legacy confirmation dialog (existing call sites) -------
export 'src/widgets/confirmation_dialog.dart';
