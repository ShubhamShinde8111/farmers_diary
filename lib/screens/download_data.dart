import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/database_helper.dart';
import '../generated/l10n.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({Key? key}) : super(key: key);

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  List<Map<String, dynamic>> farms = [];
  bool isLoading = true;
  bool _isGenerating = false;

  late Future<void> _fontsLoaded;
  late pw.Font _fontRegular;
  late pw.Font _fontBold;

  @override
  void initState() {
    super.initState();
    _fontsLoaded = _loadFonts();
    _fetchFarms();
  }

  Future<void> _loadFonts() async {
    _fontRegular = pw.Font.helvetica();
    _fontBold = pw.Font.helveticaBold();
  }

  Future<void> _fetchFarms() async {
    setState(() => isLoading = true);
    try {
      farms = await DatabaseHelper().getAllFarms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching farms: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _getCrop(Map<String, dynamic> farm) {
    return farm['crop'] ??
        farm['cropName'] ??
        farm['crop_name'] ??
        farm['cropType'] ??
        farm['crop_type'] ??
        farm['type'] ??
        'N/A';
  }

  Future<void> _addFarmReportToDocument(
      pw.Document pdf,
      Map<String, dynamic> farm,
      String locale,
      ) async {
    await _fontsLoaded;
    final crop = _getCrop(farm);

    final rawRecords = await DatabaseHelper().getFarmExpenses(farm['id']);
    final records = List<Map<String, dynamic>>.from(rawRecords);

    records.sort((a, b) {
      final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
      final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
      return da.compareTo(db);
    });

    final grouped = <String, List<Map<String, dynamic>>>{};
    double total = 0.0;
    for (var r in records) {
      DateTime? dt;
      try {
        dt = DateTime.parse(r['date'] ?? '');
      } catch (_) {}
      final dateKey = dt != null
          ? DateFormat.yMMMd(locale).format(dt)
          : (r['date']?.isNotEmpty == true ? r['date']! : 'Unknown Date');
      grouped.putIfAbsent(dateKey, () => []).add(r);
      total += double.tryParse(r['amount'].toString()) ?? 0;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              farm['name'] ?? '🌾 Farm Report',
              style: pw.TextStyle(font: _fontBold, fontSize: 24),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Generated: ${DateFormat.yMMMd(locale).add_jm().format(DateTime.now())}',
              style: pw.TextStyle(font: _fontRegular, fontSize: 10),
            ),
            pw.Divider(),
          ],
        ),
        footer: (pw.Context ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: pw.TextStyle(font: _fontRegular, fontSize: 10),
          ),
        ),
        build: (pw.Context ctx) => [
          pw.SizedBox(height: 10),
          pw.Text('Location: ${farm['location'] ?? 'N/A'}',
              style: pw.TextStyle(font: _fontRegular, fontSize: 12)),
          pw.Text('Crop: $crop',
              style: pw.TextStyle(font: _fontRegular, fontSize: 12)),
          pw.Text(
            'Area: ${farm['area'] ?? 'N/A'} ${farm['area_unit'] ?? ''}',
            style: pw.TextStyle(font: _fontRegular, fontSize: 12),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Expense Records',
              style: pw.TextStyle(font: _fontBold, fontSize: 18)),
          pw.SizedBox(height: 8),
          if (grouped.isEmpty)
            pw.Text('No expense records.',
                style: pw.TextStyle(font: _fontRegular))
          else
            for (var date in grouped.keys) ...[
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  date,
                  style: pw.TextStyle(
                    font: _fontBold,
                    fontSize: 14,
                    color: PdfColors.blueGrey900,
                  ),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: ['Description', 'Category', 'Amount'],
                headerStyle: pw.TextStyle(font: _fontBold, fontSize: 12),
                cellStyle: pw.TextStyle(font: _fontRegular, fontSize: 10),
                data: grouped[date]!.map((e) {
                  final amt = double.tryParse(e['amount'].toString()) ?? 0.0;
                  final fmt = NumberFormat.currency(
                    locale: 'en_IN',
                    symbol: 'Rs.',
                  ).format(amt);
                  return [
                    e['description'] ?? 'N/A',
                    e['category'] ?? 'N/A',
                    fmt,
                  ];
                }).toList(),
                border: pw.TableBorder.all(width: .5, color: PdfColors.grey300),
                cellPadding: pw.EdgeInsets.all(4),
              ),
              pw.SizedBox(height: 12),
            ],
          pw.Divider(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Total: ${NumberFormat.currency(locale: 'en_IN', symbol: 'Rs. ').format(total)}',
              style: pw.TextStyle(
                  font: _fontBold, fontSize: 16, color: PdfColors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndPrintPdf(
      List<Map<String, dynamic>> targetFarms,
      String filename,
      ) async {
    setState(() => _isGenerating = true);
    final locale = Localizations.localeOf(context).toString();
    try {
      await _fontsLoaded;
      final pdf = pw.Document();
      for (var farm in targetFarms) {
        await _addFarmReportToDocument(pdf, farm, locale);
      }
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: filename,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download completed: $filename')),
      );
    } catch (e, st) {
      debugPrint('PDF error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _downloadFarmData(Map<String, dynamic> farm) =>
      _generateAndPrintPdf([farm], "${farm['name']}_report.pdf");

  Future<void> _downloadAllFarmsData() {
    final filename = S.of(context)!.allFarmsReportFileName;
    return _generateAndPrintPdf(farms, filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.downloadData,
            style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: S.of(context)!.info,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(S.of(context)!.help, style: GoogleFonts.lato()),
                content:
                Text(S.of(context)!.tapToDownloadHelp, style: GoogleFonts.lato()),
                actions: [
                  TextButton(
                      child: Text(S.of(context)!.ok, style: GoogleFonts.lato()),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (farms.isEmpty)
            Center(child: Text("No farms found. Please add a farm first."))
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _downloadAllFarmsData,
                    icon: const Icon(Icons.cloud_download),
                    label: Text(
                      S.of(context)!.downloadAllFarmsData,
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final buildItem = (int i) => _farmCard(farms[i]);
                      if (constraints.maxWidth > 600) {
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: farms.length,
                          itemBuilder: (_, i) => buildItem(i),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: farms.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: buildItem(i),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          if (_isGenerating) ...[
            ModalBarrier(color: Colors.black45, dismissible: false),
            const Center(child: CircularProgressIndicator())
          ],
        ],
      ),
    );
  }

  Widget _farmCard(Map<String, dynamic> farm) {
    final crop = _getCrop(farm);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.agriculture,
            size: 32, color: Theme.of(context).primaryColor),
        title: Text(farm['name'] ?? 'No Name',
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Location: ${farm['location'] ?? 'N/A'}",
                style: GoogleFonts.lato(fontSize: 14)),
            Text("Crop: $crop",
                style: GoogleFonts.lato(fontSize: 14)),
            Text("Area: ${farm['area'] ?? 'N/A'} ${farm['area_unit'] ?? ''}",
                style: GoogleFonts.lato(fontSize: 14)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download_rounded),
          onPressed: () => _downloadFarmData(farm),
        ),
      ),
    );
  }
}
