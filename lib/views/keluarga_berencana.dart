import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart';
import '../model/kb_model.dart';
import '../viewmodels/kb_view_model.dart';

class KbFormPage extends StatefulWidget {
  const KbFormPage({super.key});

  @override
  State<KbFormPage> createState() => _KbFormPageState();
}

class _KbFormPageState extends State<KbFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _hpController = TextEditingController();
  final _alamatController = TextEditingController();
  
  String? _layananTerpilih;
  DateTime _tanggalTerpilih = DateTime.now();
  bool _isInit = true;

  // Konstanta Warna (dari Master)
  static const Color inputFillColor = Color(0xFFE8F5E9);
  static const Color iconColor = Color(0xFF388E3C);
  static const Color errorColor = Colors.red;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final data = ModalRoute.of(context)?.settings.arguments as KbModel?;
      if (data != null) {
        _namaController.text = data.nama;
        _nikController.text = data.nik;
        _hpController.text = data.hp;
        _alamatController.text = data.alamat;
        _layananTerpilih = data.layanan;
        _tanggalTerpilih = data.tanggal;
      }
      _isInit = false;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalTerpilih,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _tanggalTerpilih = picked);
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _layananTerpilih != null) {
      final dataLama = ModalRoute.of(context)?.settings.arguments as KbModel?;
      final dataBaru = KbModel(
        nama: _namaController.text,
        nik: _nikController.text,
        hp: _hpController.text,
        alamat: _alamatController.text,
        layanan: _layananTerpilih!,
        tanggal: _tanggalTerpilih,
      );

      try {
        await context.read<KbViewModel>().simpanPendaftaran(
          data: dataBaru,
          isEdit: dataLama != null,
          id: dataLama?.id,
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } else if (_layananTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap pilih jenis layanan KB")),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _hpController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<KbViewModel>();
    String formattedDate = "${_tanggalTerpilih.day}/${_tanggalTerpilih.month}/${_tanggalTerpilih.year}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: iconColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pendaftaran KB Terpadu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menggunakan _buildField (wildan2) tapi nanti isinya di-style ala Master
              _buildField(
                'Nama Lengkap :', 
                'Masukkan nama lengkap', 
                _namaController,
                validator: (v) => (v == null || v.isEmpty) ? 'Nama Lengkap harus diisi.' : null,
              ),
              
              _buildField(
                'NIK :', 
                'Sesuai KTP', 
                _nikController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.isEmpty) ? 'NIK harus diisi.' : null,
              ),
              
              _buildField(
                'No Handphone :', 
                'Nomor aktif', 
                _hpController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.isEmpty) ? 'Nomor Handphone harus diisi.' : null,
              ),
              
              _buildField(
                'Alamat :', 
                'Alamat sekarang', 
                _alamatController,
                validator: (v) => (v == null || v.isEmpty) ? 'Alamat harus diisi.' : null,
              ),

              const Text('Tanggal :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: inputFillColor, 
                    borderRadius: BorderRadius.circular(30),
                    // Menggunakan style border dari Master untuk DatePicker juga agar konsisten
                    border: Border.all(color: Colors.transparent), 
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: iconColor), 
                      const SizedBox(width: 10), 
                      Text(formattedDate, style: const TextStyle(fontSize: 16, color: iconColor, fontWeight: FontWeight.w500))
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Jenis Layanan KB :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _layananTerpilih = 'Jangka Pendek'),
                child: Row(
                  children: [
                    Icon(
                      _layananTerpilih == 'Jangka Pendek' ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _layananTerpilih == 'Jangka Pendek' ? iconColor : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Jangka Pendek', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _layananTerpilih = 'Jangka Panjang'),
                child: Row(
                  children: [
                    Icon(
                      _layananTerpilih == 'Jangka Panjang' ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _layananTerpilih == 'Jangka Panjang' ? iconColor : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text('Jangka Panjang', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor, 
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: viewModel.isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text("Daftar Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget yang Digabungkan (Logic Wildan + Style Master)
  Widget _buildField(
    String label, 
    String hint, 
    TextEditingController controller, 
    {
      TextInputType keyboardType = TextInputType.text, 
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator
    }
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator ?? (v) => v!.isEmpty ? 'Tidak boleh kosong' : null, // Default validator jika tidak ada
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true, 
              fillColor: inputFillColor,
              // Style Border Cantik dari Master
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder( // Style saat error
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: errorColor, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: errorColor, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder( // Style saat diklik
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: iconColor, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}