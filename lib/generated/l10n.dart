// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S? current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current!;
    });
  } 

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Farmer Diary`
  String get appTitle {
    return Intl.message(
      'Farmer Diary',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Farmer Diary`
  String get welcomeMessage {
    return Intl.message(
      'Welcome to the Farmer Diary',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Language changed to Hindi`
  String get languageChanged {
    return Intl.message(
      'Language changed to Hindi',
      name: 'languageChanged',
      desc: '',
      args: [],
    );
  }

  /// `Search Farm...`
  String get searchFarm {
    return Intl.message(
      'Search Farm...',
      name: 'searchFarm',
      desc: '',
      args: [],
    );
  }

  /// `Add Farm`
  String get addFarm {
    return Intl.message(
      'Add Farm',
      name: 'addFarm',
      desc: '',
      args: [],
    );
  }

  /// `Overall Expense`
  String get overallExpense {
    return Intl.message(
      'Overall Expense',
      name: 'overallExpense',
      desc: '',
      args: [],
    );
  }

  /// `Total Pesticides`
  String get totalPesticide {
    return Intl.message(
      'Total Pesticides',
      name: 'totalPesticide',
      desc: '',
      args: [],
    );
  }

  /// `Total Fertilizers`
  String get totalFertilizer {
    return Intl.message(
      'Total Fertilizers',
      name: 'totalFertilizer',
      desc: '',
      args: [],
    );
  }

  /// `Total Labour`
  String get totalLabour {
    return Intl.message(
      'Total Labour',
      name: 'totalLabour',
      desc: '',
      args: [],
    );
  }

  /// `Other Expenses`
  String get totalOther {
    return Intl.message(
      'Other Expenses',
      name: 'totalOther',
      desc: '',
      args: [],
    );
  }

  /// `Farm-wise Expenses`
  String get farmWiseExpense {
    return Intl.message(
      'Farm-wise Expenses',
      name: 'farmWiseExpense',
      desc: '',
      args: [],
    );
  }

  /// `Edit Farm`
  String get editFarm {
    return Intl.message(
      'Edit Farm',
      name: 'editFarm',
      desc: '',
      args: [],
    );
  }

  /// `Archive Farm`
  String get archiveFarm {
    return Intl.message(
      'Archive Farm',
      name: 'archiveFarm',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to archive this farm?`
  String get archiveConfirmationTitle {
    return Intl.message(
      'Are you sure you want to archive this farm?',
      name: 'archiveConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Once this farm is archived, it cannot be reactivated.`
  String get archiveConfirmationContent {
    return Intl.message(
      'Once this farm is archived, it cannot be reactivated.',
      name: 'archiveConfirmationContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Expense summary is unavailable`
  String get expenseSummaryUnavailable {
    return Intl.message(
      'Expense summary is unavailable',
      name: 'expenseSummaryUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No farms found. Please add a farm first.`
  String get noFarmsFound {
    return Intl.message(
      'No farms found. Please add a farm first.',
      name: 'noFarmsFound',
      desc: '',
      args: [],
    );
  }

  /// `Error loading expenses`
  String get expenseError {
    return Intl.message(
      'Error loading expenses',
      name: 'expenseError',
      desc: '',
      args: [],
    );
  }

  /// `Select Crop Type`
  String get cropTypeSelection {
    return Intl.message(
      'Select Crop Type',
      name: 'cropTypeSelection',
      desc: '',
      args: [],
    );
  }

  /// `Create Plot`
  String get plotCreation {
    return Intl.message(
      'Create Plot',
      name: 'plotCreation',
      desc: '',
      args: [],
    );
  }

  /// `Create Schedule`
  String get scheduleCreation {
    return Intl.message(
      'Create Schedule',
      name: 'scheduleCreation',
      desc: '',
      args: [],
    );
  }

  /// `Enter Pesticides/Fertilizer details`
  String get inputPesticidesFertilizers {
    return Intl.message(
      'Enter Pesticides/Fertilizer details',
      name: 'inputPesticidesFertilizers',
      desc: '',
      args: [],
    );
  }

  /// `Edit Schedule`
  String get editSchedule {
    return Intl.message(
      'Edit Schedule',
      name: 'editSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Track Schedule`
  String get trackSchedule {
    return Intl.message(
      'Track Schedule',
      name: 'trackSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Generate Report`
  String get generateReport {
    return Intl.message(
      'Generate Report',
      name: 'generateReport',
      desc: '',
      args: [],
    );
  }

  /// `Download PDF Report`
  String get pdfReport {
    return Intl.message(
      'Download PDF Report',
      name: 'pdfReport',
      desc: '',
      args: [],
    );
  }

  /// `Crop Type`
  String get cropType {
    return Intl.message(
      'Crop Type',
      name: 'cropType',
      desc: '',
      args: [],
    );
  }

  /// `Crop Name:`
  String get cropName {
    return Intl.message(
      'Crop Name:',
      name: 'cropName',
      desc: '',
      args: [],
    );
  }

  /// `Select Crop`
  String get selectCrop {
    return Intl.message(
      'Select Crop',
      name: 'selectCrop',
      desc: '',
      args: [],
    );
  }

  /// `Plot Name`
  String get plotName {
    return Intl.message(
      'Plot Name',
      name: 'plotName',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Task`
  String get taskSchedule {
    return Intl.message(
      'Schedule Task',
      name: 'taskSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Pesticide Name`
  String get pesticideName {
    return Intl.message(
      'Pesticide Name',
      name: 'pesticideName',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Remarks`
  String get remarks {
    return Intl.message(
      'Remarks',
      name: 'remarks',
      desc: '',
      args: [],
    );
  }

  /// `Hello Farmer`
  String get hiFarmer {
    return Intl.message(
      'Hello Farmer',
      name: 'hiFarmer',
      desc: '',
      args: [],
    );
  }

  /// `Your Farming Records`
  String get yourFarmingRecords {
    return Intl.message(
      'Your Farming Records',
      name: 'yourFarmingRecords',
      desc: '',
      args: [],
    );
  }

  /// `Add your farming record and track everything in one place`
  String get addYourFarmingRecord {
    return Intl.message(
      'Add your farming record and track everything in one place',
      name: 'addYourFarmingRecord',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add New Record`
  String get addNewRecord {
    return Intl.message(
      'Add New Record',
      name: 'addNewRecord',
      desc: '',
      args: [],
    );
  }

  /// `No records yet. Please add a farm first!`
  String get noRecordsYet {
    return Intl.message(
      'No records yet. Please add a farm first!',
      name: 'noRecordsYet',
      desc: '',
      args: [],
    );
  }

  /// `Today's Tasks`
  String get todayTasks {
    return Intl.message(
      'Today\'s Tasks',
      name: 'todayTasks',
      desc: '',
      args: [],
    );
  }

  /// `Completed Tasks`
  String get completedTasks {
    return Intl.message(
      'Completed Tasks',
      name: 'completedTasks',
      desc: '',
      args: [],
    );
  }

  /// `Pending Tasks`
  String get pendingTasks {
    return Intl.message(
      'Pending Tasks',
      name: 'pendingTasks',
      desc: '',
      args: [],
    );
  }

  /// `View Schedule`
  String get viewSchedule {
    return Intl.message(
      'View Schedule',
      name: 'viewSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Tap + button to add a new farm`
  String get tapToAddFarm {
    return Intl.message(
      'Tap + button to add a new farm',
      name: 'tapToAddFarm',
      desc: '',
      args: [],
    );
  }

  /// `No tasks scheduled for today`
  String get noTasksToday {
    return Intl.message(
      'No tasks scheduled for today',
      name: 'noTasksToday',
      desc: '',
      args: [],
    );
  }

  /// `Great job! You’ve completed all tasks for today!`
  String get goodJob {
    return Intl.message(
      'Great job! You’ve completed all tasks for today!',
      name: 'goodJob',
      desc: '',
      args: [],
    );
  }

  /// `Go to Reports`
  String get goToReports {
    return Intl.message(
      'Go to Reports',
      name: 'goToReports',
      desc: '',
      args: [],
    );
  }

  /// `Farms`
  String get farms {
    return Intl.message(
      'Farms',
      name: 'farms',
      desc: '',
      args: [],
    );
  }

  /// `Plots`
  String get plots {
    return Intl.message(
      'Plots',
      name: 'plots',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Schedules`
  String get schedules {
    return Intl.message(
      'Schedules',
      name: 'schedules',
      desc: '',
      args: [],
    );
  }

  /// `Farm added successfully!`
  String get farmAddSuccess {
    return Intl.message(
      'Farm added successfully!',
      name: 'farmAddSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Final Confirmation`
  String get finalConfirmation {
    return Intl.message(
      'Final Confirmation',
      name: 'finalConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action will archive the farm along with its expenses. You can restore them later. Are you 100% sure?`
  String get archiveWarning {
    return Intl.message(
      'This action will archive the farm along with its expenses. You can restore them later. Are you 100% sure?',
      name: 'archiveWarning',
      desc: '',
      args: [],
    );
  }

  /// `Failed to archive the farm. Please try again.`
  String get archiveFailed {
    return Intl.message(
      'Failed to archive the farm. Please try again.',
      name: 'archiveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error loading summary`
  String get summaryLoadError {
    return Intl.message(
      'Error loading summary',
      name: 'summaryLoadError',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all information`
  String get pleaseFillAllInfo {
    return Intl.message(
      'Please fill all information',
      name: 'pleaseFillAllInfo',
      desc: '',
      args: [],
    );
  }

  /// `Data cannot be saved to the web`
  String get webDataNotSaved {
    return Intl.message(
      'Data cannot be saved to the web',
      name: 'webDataNotSaved',
      desc: '',
      args: [],
    );
  }

  /// `There was an issue saving the farm!`
  String get farmSaveError {
    return Intl.message(
      'There was an issue saving the farm!',
      name: 'farmSaveError',
      desc: '',
      args: [],
    );
  }

  /// `Add New Farm`
  String get addNewFarm {
    return Intl.message(
      'Add New Farm',
      name: 'addNewFarm',
      desc: '',
      args: [],
    );
  }

  /// `Year : 2025`
  String get year {
    return Intl.message(
      'Year : 2025',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Acre`
  String get acre {
    return Intl.message(
      'Acre',
      name: 'acre',
      desc: '',
      args: [],
    );
  }

  /// `Hectare`
  String get hectare {
    return Intl.message(
      'Hectare',
      name: 'hectare',
      desc: '',
      args: [],
    );
  }

  /// `Gunta`
  String get gunta {
    return Intl.message(
      'Gunta',
      name: 'gunta',
      desc: '',
      args: [],
    );
  }

  /// `Square Meter`
  String get squareMeter {
    return Intl.message(
      'Square Meter',
      name: 'squareMeter',
      desc: '',
      args: [],
    );
  }

  /// `Square Foot`
  String get squareFoot {
    return Intl.message(
      'Square Foot',
      name: 'squareFoot',
      desc: '',
      args: [],
    );
  }

  /// `Enter Quantity`
  String get enterQuantity {
    return Intl.message(
      'Enter Quantity',
      name: 'enterQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Number of Seeds/Plants:`
  String get seedlingCount {
    return Intl.message(
      'Number of Seeds/Plants:',
      name: 'seedlingCount',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Dozen`
  String get dozen {
    return Intl.message(
      'Dozen',
      name: 'dozen',
      desc: '',
      args: [],
    );
  }

  /// `Kilogram`
  String get kilogram {
    return Intl.message(
      'Kilogram',
      name: 'kilogram',
      desc: '',
      args: [],
    );
  }

  /// `Gram`
  String get gram {
    return Intl.message(
      'Gram',
      name: 'gram',
      desc: '',
      args: [],
    );
  }

  /// `Planting Date:`
  String get plantingDate {
    return Intl.message(
      'Planting Date:',
      name: 'plantingDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Planting Date`
  String get selectPlantingDate {
    return Intl.message(
      'Select Planting Date',
      name: 'selectPlantingDate',
      desc: '',
      args: [],
    );
  }

  /// `Farm Name:`
  String get farmName {
    return Intl.message(
      'Farm Name:',
      name: 'farmName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Farm Name`
  String get enterFarmName {
    return Intl.message(
      'Enter Farm Name',
      name: 'enterFarmName',
      desc: '',
      args: [],
    );
  }

  /// `Area:`
  String get area {
    return Intl.message(
      'Area:',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Select Work Type`
  String get selectWorkType {
    return Intl.message(
      'Select Work Type',
      name: 'selectWorkType',
      desc: '',
      args: [],
    );
  }

  /// `Edit Expense`
  String get editExpense {
    return Intl.message(
      'Edit Expense',
      name: 'editExpense',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message(
      'Add Expense',
      name: 'addExpense',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get date {
    return Intl.message(
      'Date:',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Seeds`
  String get seeds {
    return Intl.message(
      'Seeds',
      name: 'seeds',
      desc: '',
      args: [],
    );
  }

  /// `Fertilizer`
  String get fertilizer {
    return Intl.message(
      'Fertilizer',
      name: 'fertilizer',
      desc: '',
      args: [],
    );
  }

  /// `Labor`
  String get labor {
    return Intl.message(
      'Labor',
      name: 'labor',
      desc: '',
      args: [],
    );
  }

  /// `Equipment`
  String get equipment {
    return Intl.message(
      'Equipment',
      name: 'equipment',
      desc: '',
      args: [],
    );
  }

  /// `Irrigation`
  String get irrigation {
    return Intl.message(
      'Irrigation',
      name: 'irrigation',
      desc: '',
      args: [],
    );
  }

  /// `Harvesting`
  String get harvesting {
    return Intl.message(
      'Harvesting',
      name: 'harvesting',
      desc: '',
      args: [],
    );
  }

  /// `Weeding`
  String get weeding {
    return Intl.message(
      'Weeding',
      name: 'weeding',
      desc: '',
      args: [],
    );
  }

  /// `Pesticide Spraying`
  String get pesticideSpraying {
    return Intl.message(
      'Pesticide Spraying',
      name: 'pesticideSpraying',
      desc: '',
      args: [],
    );
  }

  /// `Planting`
  String get planting {
    return Intl.message(
      'Planting',
      name: 'planting',
      desc: '',
      args: [],
    );
  }

  /// `Pruning`
  String get pruning {
    return Intl.message(
      'Pruning',
      name: 'pruning',
      desc: '',
      args: [],
    );
  }

  /// `Soil Testing`
  String get soilTesting {
    return Intl.message(
      'Soil Testing',
      name: 'soilTesting',
      desc: '',
      args: [],
    );
  }

  /// `Composting`
  String get composting {
    return Intl.message(
      'Composting',
      name: 'composting',
      desc: '',
      args: [],
    );
  }

  /// `Liters`
  String get liters {
    return Intl.message(
      'Liters',
      name: 'liters',
      desc: '',
      args: [],
    );
  }

  /// `Pieces`
  String get pieces {
    return Intl.message(
      'Pieces',
      name: 'pieces',
      desc: '',
      args: [],
    );
  }

  /// `Amount:`
  String get amount {
    return Intl.message(
      'Amount:',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enterAmount {
    return Intl.message(
      'Enter Amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Amount is required`
  String get amountRequired {
    return Intl.message(
      'Amount is required',
      name: 'amountRequired',
      desc: '',
      args: [],
    );
  }

  /// `Work Description`
  String get workDescription {
    return Intl.message(
      'Work Description',
      name: 'workDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter Work Description`
  String get enterWorkDescription {
    return Intl.message(
      'Enter Work Description',
      name: 'enterWorkDescription',
      desc: '',
      args: [],
    );
  }

  /// `Receipts:`
  String get receipts {
    return Intl.message(
      'Receipts:',
      name: 'receipts',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all required fields correctly`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill all required fields correctly',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Record Work/Expense`
  String get recordWorkExpense {
    return Intl.message(
      'Record Work/Expense',
      name: 'recordWorkExpense',
      desc: '',
      args: [],
    );
  }

  /// `Quantity and Unit are required`
  String get quantityUnitRequired {
    return Intl.message(
      'Quantity and Unit are required',
      name: 'quantityUnitRequired',
      desc: '',
      args: [],
    );
  }

  /// `Work name is required`
  String get workNameRequired {
    return Intl.message(
      'Work name is required',
      name: 'workNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Work Name:`
  String get workName {
    return Intl.message(
      'Work Name:',
      name: 'workName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Work Name`
  String get enterWorkName {
    return Intl.message(
      'Enter Work Name',
      name: 'enterWorkName',
      desc: '',
      args: [],
    );
  }

  /// `Quantity is required`
  String get quantityRequired {
    return Intl.message(
      'Quantity is required',
      name: 'quantityRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number`
  String get enterValidNumber {
    return Intl.message(
      'Enter a valid number',
      name: 'enterValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Unit:`
  String get unit {
    return Intl.message(
      'Unit:',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Unit is required`
  String get unitRequired {
    return Intl.message(
      'Unit is required',
      name: 'unitRequired',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save expense. Please try again.`
  String get failedToSaveExpense {
    return Intl.message(
      'Failed to save expense. Please try again.',
      name: 'failedToSaveExpense',
      desc: '',
      args: [],
    );
  }

  /// `Please enter both name and location!`
  String get enterNameAndLocation {
    return Intl.message(
      'Please enter both name and location!',
      name: 'enterNameAndLocation',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update farm. Please try again!`
  String get failedToUpdateFarm {
    return Intl.message(
      'Failed to update farm. Please try again!',
      name: 'failedToUpdateFarm',
      desc: '',
      args: [],
    );
  }

  /// `Edit Farm Details`
  String get editFarmDetails {
    return Intl.message(
      'Edit Farm Details',
      name: 'editFarmDetails',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Update Farm`
  String get updateFarm {
    return Intl.message(
      'Update Farm',
      name: 'updateFarm',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Expense updated successfully!`
  String get expenseUpdatedSuccess {
    return Intl.message(
      'Expense updated successfully!',
      name: 'expenseUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Archive Expense?`
  String get archiveExpense {
    return Intl.message(
      'Archive Expense?',
      name: 'archiveExpense',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to archive this expense?`
  String get archiveExpenseConfirmation {
    return Intl.message(
      'Are you sure you want to archive this expense?',
      name: 'archiveExpenseConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Expense archived successfully!`
  String get expenseArchivedSuccess {
    return Intl.message(
      'Expense archived successfully!',
      name: 'expenseArchivedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to archive expense. Please try again.`
  String get expenseArchiveFailed {
    return Intl.message(
      'Failed to archive expense. Please try again.',
      name: 'expenseArchiveFailed',
      desc: '',
      args: [],
    );
  }

  /// `No expenses found.`
  String get noExpensesFound {
    return Intl.message(
      'No expenses found.',
      name: 'noExpensesFound',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Download completed for all farms`
  String get downloadCompletedAllFarms {
    return Intl.message(
      'Download completed for all farms',
      name: 'downloadCompletedAllFarms',
      desc: '',
      args: [],
    );
  }

  /// `all_farms_report.pdf`
  String get allFarmsReportFileName {
    return Intl.message(
      'all_farms_report.pdf',
      name: 'allFarmsReportFileName',
      desc: '',
      args: [],
    );
  }

  /// `Downloading all farms report...`
  String get downloadingAllFarmsReport {
    return Intl.message(
      'Downloading all farms report...',
      name: 'downloadingAllFarmsReport',
      desc: '',
      args: [],
    );
  }

  /// `Download Data`
  String get downloadData {
    return Intl.message(
      'Download Data',
      name: 'downloadData',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Tap on a farm to download its report, or use the button above to download all.`
  String get tapToDownloadHelp {
    return Intl.message(
      'Tap on a farm to download its report, or use the button above to download all.',
      name: 'tapToDownloadHelp',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Download All Farms Data`
  String get downloadAllFarmsData {
    return Intl.message(
      'Download All Farms Data',
      name: 'downloadAllFarmsData',
      desc: '',
      args: [],
    );
  }

  /// `Failed to archive expense. Please try again.`
  String get failedToArchiveExpense {
    return Intl.message(
      'Failed to archive expense. Please try again.',
      name: 'failedToArchiveExpense',
      desc: '',
      args: [],
    );
  }

  /// `Day-wise Expenses`
  String get dayWiseExpenses {
    return Intl.message(
      'Day-wise Expenses',
      name: 'dayWiseExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Farm`
  String get unknownFarm {
    return Intl.message(
      'Unknown Farm',
      name: 'unknownFarm',
      desc: '',
      args: [],
    );
  }

  /// `Please select a crop category to continue.`
  String get select_crop_category {
    return Intl.message(
      'Please select a crop category to continue.',
      name: 'select_crop_category',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get otherCrop {
    return Intl.message(
      'Other',
      name: 'otherCrop',
      desc: '',
      args: [],
    );
  }

  /// `Enter Crop Name`
  String get enterCropName {
    return Intl.message(
      'Enter Crop Name',
      name: 'enterCropName',
      desc: '',
      args: [],
    );
  }

  /// `Enter here...`
  String get enterHere {
    return Intl.message(
      'Enter here...',
      name: 'enterHere',
      desc: '',
      args: [],
    );
  }

  /// `Expense Records`
  String get expenseRecords {
    return Intl.message(
      'Expense Records',
      name: 'expenseRecords',
      desc: '',
      args: [],
    );
  }

  /// `Crop`
  String get crop {
    return Intl.message(
      'Crop',
      name: 'crop',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Download completed:`
  String get downloadCompleted {
    return Intl.message(
      'Download completed:',
      name: 'downloadCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate PDF`
  String get failedToGeneratePdf {
    return Intl.message(
      'Failed to generate PDF',
      name: 'failedToGeneratePdf',
      desc: '',
      args: [],
    );
  }

  /// `PDF error:`
  String get pdfError {
    return Intl.message(
      'PDF error:',
      name: 'pdfError',
      desc: '',
      args: [],
    );
  }

  /// `_report.pdf`
  String get reportPdf {
    return Intl.message(
      '_report.pdf',
      name: 'reportPdf',
      desc: '',
      args: [],
    );
  }

  /// `No expense records.`
  String get noExpenseRecords {
    return Intl.message(
      'No expense records.',
      name: 'noExpenseRecords',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'mr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}