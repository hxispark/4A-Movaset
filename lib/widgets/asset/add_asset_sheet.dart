import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../theme/app_theme.dart';
import 'sheet_input.dart';

class AddAssetSheet extends StatefulWidget {
  final ScrollController scrollController;
  const AddAssetSheet({super.key, required this.scrollController});

  @override
  State<AddAssetSheet> createState() => _AddAssetSheetState();
}

class _AddAssetSheetState extends State<AddAssetSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _status   = 'tidak';
  String _category = 'Elektronik';
  String _pjNama   = '';
  bool _isLoading  = false;

  static const _slotLabels = [
    'Depan', 'Belakang', 'Kiri', 'Kanan', 'Atas', 'Bawah'
  ];

  final List<Uint8List?> _imageBytes = List.filled(6, null);
  final List<String?>    _imageNames = List.filled(6, null);

  static const _categories = ['Elektronik'];

  @override
  void initState() {
    super.initState();
    _loadPJ();
  }

  Future<void> _loadPJ() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _pjNama = prefs.getString('logged_in_user') ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  int get _filledCount => _imageBytes.where((b) => b != null).length;
  bool get _allFilled  => _filledCount == 6;

  // ── Pilih sumber foto untuk 1 slot ────────────────────────────
  void _showSourcePicker(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCDD3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Ganti Foto',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (!kIsWeb)
                    Expanded(
                      child: _SourceButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        color: AppColors.blue,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(index, ImageSource.camera);
                        },
                      ),
                    ),
                  if (!kIsWeb) const SizedBox(width: 12),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Galeri',
                      color: AppColors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(index, ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 60,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes[index] = bytes;
      _imageNames[index] = picked.name;
    });
  }

  // ── Pilih semua foto sekaligus ─────────────────────────────────
  Future<void> _pickAllFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(
      imageQuality: 60,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (picked.isEmpty) return;

    final toAdd = picked.take(6).toList();
    for (int i = 0; i < toAdd.length; i++) {
      final bytes = await toAdd[i].readAsBytes();
      setState(() {
        _imageBytes[i] = bytes;
        _imageNames[i] = toAdd[i].name;
      });
    }

    _snack(
      '${toAdd.length} foto berhasil dimuat',
      AppColors.green,
    );
  }

  void _removeImage(int index) {
    setState(() {
      _imageBytes[index] = null;
      _imageNames[index] = null;
    });
  }

  // ── Upload paralel ─────────────────────────────────────────────
  Future<List<String>> _uploadImages(String uuid) async {
    final futures = <Future<String>>[];
    for (int i = 0; i < _imageBytes.length; i++) {
      final bytes = _imageBytes[i];
      if (bytes == null) continue;
      final ref = FirebaseStorage.instance.ref('assets/$uuid/image_$i.jpg');
      futures.add(
        ref
          .putData(bytes, SettableMetadata(contentType: 'image/jpeg'))
          .then((_) => ref.getDownloadURL()),
      );
    }
    return Future.wait(futures);
  }

  // ── Simpan ────────────────────────────────────────────────────
  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _snack('Nama aset harus diisi', const Color(0xFFEF4444));
      return;
    }
    if (!_allFilled) {
      _snack('Lengkapi semua 6 foto aset terlebih dahulu', const Color(0xFFEF4444));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final uuid      = const Uuid().v4();
      final imageUrls = await _uploadImages(uuid);
      await FirebaseFirestore.instance.collection('assets').doc(uuid).set({
        'name':             _nameCtrl.text.trim(),
        'description':      _descCtrl.text.trim(),
        'category':         _category,
        'penanggung_jawab': _pjNama,
        'status':           _status,
        'images':           imageUrls,
        'created_at':       FieldValue.serverTimestamp(),
        'updated_at':       FieldValue.serverTimestamp(),
        'deleted_at':       null,
      });
      if (!mounted) return;
      Navigator.pop(context);
      _snack('Aset "${_nameCtrl.text}" berhasil ditambahkan', AppColors.green);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _snack('Gagal menyimpan: $e', const Color(0xFFEF4444));
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCDD3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(r.hPad, 16, r.hPad, 0),
            child: Row(
              children: [
                const Icon(Icons.add_box_rounded, color: AppColors.orange, size: 20),
                const SizedBox(width: 8),
                Text('Tambah Aset Baru',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w700,
                    fontSize: r.scaledFont(15),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(r.hPad, 0, r.hPad, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SheetInput(ctrl: _nameCtrl, label: 'Nama Aset',  hint: 'Contoh: Laptop Teknik'),
                  const SizedBox(height: 12),
                  SheetInput(ctrl: _descCtrl, label: 'Deskripsi',  hint: 'Deskripsi singkat aset'),
                  const SizedBox(height: 16),

                  // ── Kategori ──
                  _label('Kategori', r),
                  const SizedBox(height: 6),
                  _dropdownBox(
                    value: _category,
                    items: _categories,
                    r: r,
                    onChanged: (v) { if (v != null) setState(() => _category = v); },
                  ),
                  const SizedBox(height: 16),

                  // ── Penanggung Jawab ──
                  _label('Penanggung Jawab', r),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E4EA), width: 1.2),
                    ),
                    child: Row(children: [
                      const Icon(Icons.person_outline_rounded,
                          size: 16, color: Color(0xFF9AA0B2)),
                      const SizedBox(width: 8),
                      Text(
                        _pjNama.isEmpty ? 'Memuat...' : _pjNama,
                        style: GoogleFonts.poppins(
                          color: _pjNama.isEmpty
                              ? const Color(0xFFB0B3BE)
                              : const Color(0xFF1A1A2E),
                          fontSize: r.scaledFont(13),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  // ── Status ──
                  _label('Status Aset', r),
                  const SizedBox(height: 8),
                  Row(
                    children: ['tidak', 'dipinjam'].map((s) {
                      final active = _status == s;
                      final color  = s == 'dipinjam'
                          ? const Color(0xFFFF9A2E)
                          : const Color(0xFF1DBF8A);
                      return GestureDetector(
                        onTap: () => setState(() => _status = s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? color.withOpacity(0.12) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? color : const Color(0xFFE2E4EA),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            s == 'dipinjam' ? 'Dipinjam' : 'Tidak Dipinjam',
                            style: GoogleFonts.poppins(
                              color: active ? color : const Color(0xFF9AA0B2),
                              fontSize: r.scaledFont(12),
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ── Foto Aset ──
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Foto Aset (6 Sisi)', r),
                            const SizedBox(height: 2),
                            Text(
                              'Foto dari 6 arah: depan, belakang, kiri, kanan, atas, bawah',
                              style: GoogleFonts.poppins(
                                fontSize: r.scaledFont(10),
                                color: const Color(0xFF9AA0B2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _pickAllFromGallery,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.blue.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_library_rounded,
                                  color: AppColors.blue, size: 14),
                              const SizedBox(width: 4),
                              Text('Pilih 6 Foto',
                                style: GoogleFonts.poppins(
                                  color: AppColors.blue,
                                  fontSize: r.scaledFont(11),
                                  fontWeight: FontWeight.w600,
                                )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Progress bar foto
                  Row(
                    children: [
                      ...List.generate(6, (i) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 5 ? 4 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: _imageBytes[i] != null
                                ? AppColors.green
                                : const Color(0xFFE2E4EA),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )),
                      const SizedBox(width: 8),
                      Text(
                        '$_filledCount/6',
                        style: GoogleFonts.poppins(
                          fontSize: r.scaledFont(11),
                          fontWeight: FontWeight.w700,
                          color: _allFilled
                              ? AppColors.green
                              : const Color(0xFF9AA0B2),
                        ),
                      ),
                    ],
                  ),

                  // ── Grid foto — hanya tampil kalau ada foto ──
                  if (_filledCount > 0) ...[
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 6,
                      itemBuilder: (_, i) {
                        final bytes = _imageBytes[i];
                        if (bytes == null) return const SizedBox.shrink();
                        return Stack(
                          children: [
                            // Foto
                            GestureDetector(
                              onTap: () => _showSourcePicker(i),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(bytes,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            // Checkmark hijau
                            Positioned(
                              top: 4, left: 4,
                              child: Container(
                                width: 20, height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 12),
                              ),
                            ),

                            // Tombol hapus
                            Positioned(
                              top: 4, right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(i),
                                child: Container(
                                  width: 22, height: 22,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],

                  // Peringatan belum lengkap
                  if (!_allFilled && _filledCount > 0) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFFF9A2E).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: Color(0xFFFF9A2E), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Masih ada ${6 - _filledCount} foto yang belum diisi',
                              style: GoogleFonts.poppins(
                                fontSize: r.scaledFont(11),
                                color: const Color(0xFFFF9A2E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ── Tombol Simpan ──
                  GestureDetector(
                    onTap: _isLoading ? null : _save,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: !_allFilled
                            ? AppColors.orange.withOpacity(0.4)
                            : _isLoading
                                ? AppColors.orange.withOpacity(0.6)
                                : AppColors.orange,
                        borderRadius: AppRadius.sm,
                        boxShadow: _allFilled
                            ? const [BoxShadow(
                                color: Color(0x28FF6B00),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              )]
                            : [],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.save_rounded,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    _allFilled
                                        ? 'Simpan Aset'
                                        : 'Lengkapi 6 Foto Dulu',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: r.scaledFont(14),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Tombol Batal ──
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.sm,
                        border: Border.all(color: const Color(0xFFE2E4EA), width: 1.2),
                      ),
                      child: Center(
                        child: Text('Batal',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF9AA0B2),
                            fontWeight: FontWeight.w600,
                            fontSize: r.scaledFont(14),
                          )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, Responsive r) => Text(text,
    style: GoogleFonts.poppins(
      color: const Color(0xFF6B7280),
      fontSize: r.scaledFont(12),
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _dropdownBox({
    required String value,
    required List<String> items,
    required Responsive r,
    required ValueChanged<String?> onChanged,
  }) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E4EA), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontSize: r.scaledFont(13),
          ),
          icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF9CA3AF)),
          onChanged: onChanged,
          items: items.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        ),
      ),
    );
}

// ── Tombol sumber foto ─────────────────────────────────────────────
class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2), width: 1.2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
          ],
        ),
      ),
    );
  }
}