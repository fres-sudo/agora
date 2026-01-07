///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Hello $name'
	String hello({required Object name}) => 'Hello ${name}';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	late final TranslationsLoginEn login = TranslationsLoginEn._(_root);
	late final TranslationsReportEn report = TranslationsReportEn._(_root);
	late final TranslationsPosEn pos = TranslationsPosEn._(_root);
	late final TranslationsProductsEn products = TranslationsProductsEn._(_root);
}

// Path: login
class TranslationsLoginEn {
	TranslationsLoginEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Logged in successfully'
	String get success => 'Logged in successfully';

	/// en: 'Logged in failed'
	String get fail => 'Logged in failed';
}

// Path: report
class TranslationsReportEn {
	TranslationsReportEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Report'
	String get title => 'Report';

	/// en: 'Download'
	String get download => 'Download';

	/// en: 'Last 6 Month'
	String get last_6_month => 'Last 6 Month';

	/// en: 'Total Order'
	String get total_order => 'Total Order';

	/// en: 'Total Revenue'
	String get total_revenue => 'Total Revenue';

	/// en: 'Total Customer'
	String get total_customer => 'Total Customer';

	/// en: 'New Customer'
	String get new_customer => 'New Customer';

	/// en: 'Sales Overview'
	String get sales_overview => 'Sales Overview';

	/// en: 'Sales'
	String get sales => 'Sales';

	/// en: 'Top 10 Product'
	String get top_10_product => 'Top 10 Product';

	late final TranslationsReportProductStatusEn product_status = TranslationsReportProductStatusEn._(_root);
	late final TranslationsReportStockStatusEn stock_status = TranslationsReportStockStatusEn._(_root);
	late final TranslationsReportRecentOrderEn recent_order = TranslationsReportRecentOrderEn._(_root);
}

// Path: pos
class TranslationsPosEn {
	TranslationsPosEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All Menu'
	String get all_menu => 'All Menu';

	/// en: 'Search Product...'
	String get search_product => 'Search Product...';

	/// en: 'Order Details'
	String get order_details => 'Order Details';

	/// en: 'Dine In'
	String get dine_in => 'Dine In';

	/// en: 'Take Away'
	String get take_away => 'Take Away';

	/// en: 'No Product Found'
	String get no_product_found => 'No Product Found';

	/// en: 'Product from your store will show here. Tap button below to add your product now'
	String get no_product_description => 'Product from your store will show here. Tap button below to add your product now';

	/// en: 'Add Product'
	String get add_product => 'Add Product';

	/// en: 'No Order'
	String get no_order => 'No Order';

	/// en: 'Tap the product to add into order'
	String get no_order_description => 'Tap the product to add into order';

	/// en: 'Clear All Order'
	String get clear_all_order => 'Clear All Order';

	/// en: 'Subtotal'
	String get subtotal => 'Subtotal';

	/// en: 'Tax'
	String get tax => 'Tax';

	/// en: 'Voucher'
	String get voucher => 'Voucher';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Process Transaction'
	String get process_transaction => 'Process Transaction';

	/// en: 'Customer'
	String get customer => 'Customer';

	/// en: 'Tables'
	String get tables => 'Tables';

	/// en: 'Discount'
	String get discount => 'Discount';

	/// en: 'Save Bill'
	String get save_bill => 'Save Bill';
}

// Path: products
class TranslationsProductsEn {
	TranslationsProductsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product'
	String get title => 'Product';

	/// en: 'Add Product'
	String get add_product => 'Add Product';

	/// en: 'Edit Product'
	String get edit_product => 'Edit Product';

	/// en: 'Search product name...'
	String get search_hint => 'Search product name...';

	late final TranslationsProductsColumnsEn columns = TranslationsProductsColumnsEn._(_root);
	late final TranslationsProductsStatusEn status = TranslationsProductsStatusEn._(_root);
	late final TranslationsProductsFormEn form = TranslationsProductsFormEn._(_root);
	late final TranslationsProductsActionsEn actions = TranslationsProductsActionsEn._(_root);
	late final TranslationsProductsMessagesEn messages = TranslationsProductsMessagesEn._(_root);
	late final TranslationsProductsEmptyEn empty = TranslationsProductsEmptyEn._(_root);
}

// Path: report.product_status
class TranslationsReportProductStatusEn {
	TranslationsReportProductStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Status'
	String get title => 'Product Status';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';

	/// en: 'Draft'
	String get draft => 'Draft';

	/// en: 'Total Product'
	String get total => 'Total Product';
}

// Path: report.stock_status
class TranslationsReportStockStatusEn {
	TranslationsReportStockStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stock Status'
	String get title => 'Stock Status';

	/// en: 'In Stock'
	String get in_stock => 'In Stock';

	/// en: 'Low Stock'
	String get low_stock => 'Low Stock';

	/// en: 'Out of Stock'
	String get out_of_stock => 'Out of Stock';

	/// en: 'Total Item'
	String get total => 'Total Item';
}

// Path: report.recent_order
class TranslationsReportRecentOrderEn {
	TranslationsReportRecentOrderEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Recent Order'
	String get title => 'Recent Order';

	/// en: 'Show All'
	String get show_all => 'Show All';

	/// en: 'ID'
	String get id => 'ID';

	/// en: 'STATUS'
	String get status => 'STATUS';

	/// en: 'ORDER DATE'
	String get order_date => 'ORDER DATE';

	/// en: 'CUSTOMER'
	String get customer => 'CUSTOMER';

	/// en: 'ORDER TYPE'
	String get order_type => 'ORDER TYPE';

	/// en: 'QTY'
	String get qty => 'QTY';

	/// en: 'TOTAL'
	String get total => 'TOTAL';
}

// Path: products.columns
class TranslationsProductsColumnsEn {
	TranslationsProductsColumnsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ID'
	String get id => 'ID';

	/// en: 'Product Name'
	String get product_name => 'Product Name';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Stock'
	String get stock => 'Stock';

	/// en: 'Price'
	String get price => 'Price';

	/// en: 'Status'
	String get status => 'Status';
}

// Path: products.status
class TranslationsProductsStatusEn {
	TranslationsProductsStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';

	/// en: 'Draft'
	String get draft => 'Draft';
}

// Path: products.form
class TranslationsProductsFormEn {
	TranslationsProductsFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductsFormStepsEn steps = TranslationsProductsFormStepsEn._(_root);

	/// en: 'Product Name'
	String get product_name => 'Product Name';

	/// en: 'Category'
	String get category => 'Category';

	/// en: 'Select Category'
	String get select_category => 'Select Category';

	/// en: 'Description'
	String get description => 'Description';

	/// en: 'Enter product description...'
	String get description_hint => 'Enter product description...';

	/// en: 'SKU'
	String get sku => 'SKU';

	/// en: 'Enter SKU or barcode...'
	String get sku_hint => 'Enter SKU or barcode...';

	/// en: 'Price'
	String get price => 'Price';

	/// en: 'Tax'
	String get tax => 'Tax';

	/// en: 'Qty'
	String get qty => 'Qty';

	/// en: 'Unlimited Availability'
	String get unlimited_availability => 'Unlimited Availability';

	/// en: 'Enable this setting to keep product stock unaffected by ingredients usage'
	String get unlimited_availability_desc => 'Enable this setting to keep product stock unaffected by ingredients usage';

	/// en: 'Search ingredient...'
	String get search_ingredient => 'Search ingredient...';

	/// en: 'Availability based on ingredients'
	String get availability_based_on_ingredients => 'Availability based on ingredients';

	/// en: 'Search the ingredient and select to view the availability'
	String get search_ingredient_hint => 'Search the ingredient and select to view the availability';
}

// Path: products.actions
class TranslationsProductsActionsEn {
	TranslationsProductsActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save as Draft'
	String get save_as_draft => 'Save as Draft';
}

// Path: products.messages
class TranslationsProductsMessagesEn {
	TranslationsProductsMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Added'
	String get product_added => 'Product Added';

	/// en: 'New product has been successfully added'
	String get product_added_desc => 'New product has been successfully added';

	/// en: 'Product Updated'
	String get product_updated => 'Product Updated';

	/// en: 'Product has been successfully updated'
	String get product_updated_desc => 'Product has been successfully updated';

	/// en: 'Product Deleted'
	String get product_deleted => 'Product Deleted';

	/// en: 'Product has been successfully deleted'
	String get product_deleted_desc => 'Product has been successfully deleted';

	/// en: 'Delete Product?'
	String get delete_confirm_title => 'Delete Product?';

	/// en: 'Are you sure you want to delete this product? This action cannot be undone.'
	String get delete_confirm_message => 'Are you sure you want to delete this product? This action cannot be undone.';
}

// Path: products.empty
class TranslationsProductsEmptyEn {
	TranslationsProductsEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Products Found'
	String get title => 'No Products Found';

	/// en: 'Add a product to get started'
	String get subtitle => 'Add a product to get started';
}

// Path: products.form.steps
class TranslationsProductsFormStepsEn {
	TranslationsProductsFormStepsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product Info'
	String get product_info => 'Product Info';

	/// en: 'Define the details of your product'
	String get product_info_desc => 'Define the details of your product';

	/// en: 'Pricing'
	String get pricing => 'Pricing';

	/// en: 'Set the price and tax'
	String get pricing_desc => 'Set the price and tax';

	/// en: 'Variants & Modifiers'
	String get variants_modifiers => 'Variants & Modifiers';

	/// en: 'Set variations and add customizable options'
	String get variants_modifiers_desc => 'Set variations and add customizable options';

	/// en: 'Ingredients'
	String get ingredients => 'Ingredients';

	/// en: 'Define ingredients and manage stock'
	String get ingredients_desc => 'Define ingredients and manage stock';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'hello' => ({required Object name}) => 'Hello ${name}',
			'save' => 'Save',
			'cancel' => 'Cancel',
			'back' => 'Back',
			'next' => 'Next',
			'add' => 'Add',
			'edit' => 'Edit',
			'delete' => 'Delete',
			'login.success' => 'Logged in successfully',
			'login.fail' => 'Logged in failed',
			'report.title' => 'Report',
			'report.download' => 'Download',
			'report.last_6_month' => 'Last 6 Month',
			'report.total_order' => 'Total Order',
			'report.total_revenue' => 'Total Revenue',
			'report.total_customer' => 'Total Customer',
			'report.new_customer' => 'New Customer',
			'report.sales_overview' => 'Sales Overview',
			'report.sales' => 'Sales',
			'report.top_10_product' => 'Top 10 Product',
			'report.product_status.title' => 'Product Status',
			'report.product_status.active' => 'Active',
			'report.product_status.inactive' => 'Inactive',
			'report.product_status.draft' => 'Draft',
			'report.product_status.total' => 'Total Product',
			'report.stock_status.title' => 'Stock Status',
			'report.stock_status.in_stock' => 'In Stock',
			'report.stock_status.low_stock' => 'Low Stock',
			'report.stock_status.out_of_stock' => 'Out of Stock',
			'report.stock_status.total' => 'Total Item',
			'report.recent_order.title' => 'Recent Order',
			'report.recent_order.show_all' => 'Show All',
			'report.recent_order.id' => 'ID',
			'report.recent_order.status' => 'STATUS',
			'report.recent_order.order_date' => 'ORDER DATE',
			'report.recent_order.customer' => 'CUSTOMER',
			'report.recent_order.order_type' => 'ORDER TYPE',
			'report.recent_order.qty' => 'QTY',
			'report.recent_order.total' => 'TOTAL',
			'pos.all_menu' => 'All Menu',
			'pos.search_product' => 'Search Product...',
			'pos.order_details' => 'Order Details',
			'pos.dine_in' => 'Dine In',
			'pos.take_away' => 'Take Away',
			'pos.no_product_found' => 'No Product Found',
			'pos.no_product_description' => 'Product from your store will show here. Tap button below to add your product now',
			'pos.add_product' => 'Add Product',
			'pos.no_order' => 'No Order',
			'pos.no_order_description' => 'Tap the product to add into order',
			'pos.clear_all_order' => 'Clear All Order',
			'pos.subtotal' => 'Subtotal',
			'pos.tax' => 'Tax',
			'pos.voucher' => 'Voucher',
			'pos.total' => 'Total',
			'pos.process_transaction' => 'Process Transaction',
			'pos.customer' => 'Customer',
			'pos.tables' => 'Tables',
			'pos.discount' => 'Discount',
			'pos.save_bill' => 'Save Bill',
			'products.title' => 'Product',
			'products.add_product' => 'Add Product',
			'products.edit_product' => 'Edit Product',
			'products.search_hint' => 'Search product name...',
			'products.columns.id' => 'ID',
			'products.columns.product_name' => 'Product Name',
			'products.columns.category' => 'Category',
			'products.columns.stock' => 'Stock',
			'products.columns.price' => 'Price',
			'products.columns.status' => 'Status',
			'products.status.active' => 'Active',
			'products.status.inactive' => 'Inactive',
			'products.status.draft' => 'Draft',
			'products.form.steps.product_info' => 'Product Info',
			'products.form.steps.product_info_desc' => 'Define the details of your product',
			'products.form.steps.pricing' => 'Pricing',
			'products.form.steps.pricing_desc' => 'Set the price and tax',
			'products.form.steps.variants_modifiers' => 'Variants & Modifiers',
			'products.form.steps.variants_modifiers_desc' => 'Set variations and add customizable options',
			'products.form.steps.ingredients' => 'Ingredients',
			'products.form.steps.ingredients_desc' => 'Define ingredients and manage stock',
			'products.form.product_name' => 'Product Name',
			'products.form.category' => 'Category',
			'products.form.select_category' => 'Select Category',
			'products.form.description' => 'Description',
			'products.form.description_hint' => 'Enter product description...',
			'products.form.sku' => 'SKU',
			'products.form.sku_hint' => 'Enter SKU or barcode...',
			'products.form.price' => 'Price',
			'products.form.tax' => 'Tax',
			'products.form.qty' => 'Qty',
			'products.form.unlimited_availability' => 'Unlimited Availability',
			'products.form.unlimited_availability_desc' => 'Enable this setting to keep product stock unaffected by ingredients usage',
			'products.form.search_ingredient' => 'Search ingredient...',
			'products.form.availability_based_on_ingredients' => 'Availability based on ingredients',
			'products.form.search_ingredient_hint' => 'Search the ingredient and select to view the availability',
			'products.actions.save_as_draft' => 'Save as Draft',
			'products.messages.product_added' => 'Product Added',
			'products.messages.product_added_desc' => 'New product has been successfully added',
			'products.messages.product_updated' => 'Product Updated',
			'products.messages.product_updated_desc' => 'Product has been successfully updated',
			'products.messages.product_deleted' => 'Product Deleted',
			'products.messages.product_deleted_desc' => 'Product has been successfully deleted',
			'products.messages.delete_confirm_title' => 'Delete Product?',
			'products.messages.delete_confirm_message' => 'Are you sure you want to delete this product? This action cannot be undone.',
			'products.empty.title' => 'No Products Found',
			'products.empty.subtitle' => 'Add a product to get started',
			_ => null,
		};
	}
}
