import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_login/service/NotificationService.dart';
import 'package:flutter_login/service/NoticationWater.dart';
import 'package:flutter_login/widgets/AlimentSaudavel.dart';
import 'package:flutter_login/settings/Config.dart';
import 'package:flutter_login/screens/InfoObri.dart';
import 'package:flutter_login/widgets/PlanoAlimentacao.dart';
import 'package:flutter_login/widgets/PlanoTreino.dart';
import 'package:flutter_login/settings/Suporte.dart';
import 'package:flutter_login/settings/theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/ImageStorage.dart';
import '../service/SharedUser.dart';
import '../widgets/ExerciseList.dart';
import 'package:windows_notification/windows_notification.dart';


class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  String _userName = "Nome do usuário";
  String _userEmail = "email_do_usuario@gmail.com";
  double _imc = 0.0;
  bool valor = false;
  String?_selectedImagePath; // Variável para armazenar o caminho da imagem selecionada
  Uint8List? _selectedImageBytes;
  final ImageStorage _imageStorage = ImageStorage();
  final LocalStorage localStorage = LocalStorage('my_app');
  final _winNotifyPlugin = WindowsNotification(applicationId: null);
  final notificationService = NotificationWater.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserImage();
    // notificationService.showWaterReminderNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
    _loadUserImage();
  }

  showNotification() {
    setState(() {
      valor = !valor;
      if (valor) {
        Provider.of<NotificationService>(context, listen: false)
            .showNotification(CustomNotification(
                id: 1,
                title: "Teste",
                body: "Bem Vindo",
                payload: "notificacao"));
      }
    });
  }

  Future<void> _saveImageToLocalStorage(Uint8List imageBytes) async {
    final userId = await getUserUniqueId();
    final localStorage = LocalStorage('my_app');
    await localStorage.ready;

    // Codifica a lista de bytes em uma representação de texto
    final encodedImage = base64Encode(imageBytes);

    await localStorage.setItem(userId, encodedImage);
  }

  Future<String?> _saveUserImage(String userId, Uint8List imageBytes) async {
    final userData = await SharedUser.getUserData();
    String idUsuario = userData!.idUsuario.toString();
    final fileName = 'user_profile${idUsuario}.png';
    return await ImageStorage().saveUserImage(userId, imageBytes, fileName);
  }

  Future<String> getUserUniqueId() async {
    final userData = await SharedUser.getUserData();
    return userData!.idUsuario.toString();
  }

  Future<Uint8List?> _loadUserImage() async {
    if (kIsWeb) {
      final userId = await getUserUniqueId();
      final localStorage = LocalStorage('my_app');
      await localStorage.ready;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final encodedImage = prefs.getString('user_profile${userId}.png');

      if (userId != null) {
        // final dynamic encodedImage = await localStorage.getItem(userId.toString());

        if (encodedImage is String) {
          // Decodifica a representação de texto para obter a lista de bytes
          final imageBytes = base64Decode(encodedImage);
          _selectedImageBytes = imageBytes;
          return Uint8List.fromList(imageBytes);
        }
      }
    } else {
      return _selectedImageBytes;
    }

    return null;
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.single;
      String? selectedImagePath;

      if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
        if (kIsWeb) {
          final localStorage = LocalStorage('my_app');
          await localStorage.ready;

          final userId = await getUserUniqueId();
          await localStorage.setItem(userId.toString(), platformFile.bytes);
          selectedImagePath = userId.toString();
        } else {
          final userId = await getUserUniqueId();
          selectedImagePath =
              await _saveUserImage(userId.toString(), platformFile.bytes!);
        }
      }

      setState(() {
        _selectedImagePath = selectedImagePath;
        _selectedImageBytes = platformFile.bytes;
      });
    }
  }

  Future<void> _pickImageLocal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.single;

      if (platformFile.bytes != null && platformFile.bytes!.isNotEmpty) {
        final encodedImage = base64Encode(platformFile.bytes!);
        await _saveImageToLocalStorage(platformFile.bytes!);
        await SharedUser.saveImageToSharedPreferences(encodedImage);
        setState(() {
          _selectedImageBytes = platformFile.bytes;
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    final userData = await SharedUser.getUserData();
    if (userData != null) {
      setState(() {
        _userName = userData.usuario;
        _userEmail = userData.email;
        _imc = userData.imc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: AppTheme.iconColor),
          backgroundColor: AppTheme.appBarColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: AppTheme.iconColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfiguracoesPage(),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Row(
                  children: [
                    const Icon(Icons.person,
                        color: Colors.black, size: 16.0), // Ícone de usuário
                    const SizedBox(width: 8.0),
                    const Text("Username:",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4.0),
                    Text("${_userName}", style: TextStyle(fontSize: 14.0))
                  ],
                ),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Icon(Icons.email,
                            color: Colors.black, size: 16.0), // Ícone de e-mail
                        const SizedBox(width: 8.0),
                        const Text("E-mail:",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4.0),
                        Text("${_userEmail}", style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.monitor_weight,
                            color: Colors.black,
                            size: 16.0), // Ícone para o IMC
                        const SizedBox(width: 8.0),
                        const Text("IMC:",
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4.0),
                        Text("${_imc.toStringAsFixed(1)}",
                            style: TextStyle(fontSize: 14.0))
                      ],
                    ),
                  ],
                ),
                currentAccountPicture: GestureDetector(
                  onTap: () => _pickImageLocal(),
                  child: CircleAvatar(
                    backgroundImage: _selectedImageBytes != null
                        ? Image.memory(Uint8List.fromList(_selectedImageBytes!))
                            .image
                        : AssetImage('assets/images/user_profile.png'),
                    backgroundColor: Colors.lightBlue,
                    radius: 30.0, // Tamanho do avatar
                  ),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.blue], // Cores do degradê
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Informações Pessoais',
                    style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.person_outline, color: Colors.blue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoForm(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Plano de Treino',
                    style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.food_bank, color: Colors.green),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanoTreinoPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Plano de Dieta',
                    style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.restaurant_menu, color: Colors.red),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Diet() //PlanoAlimentacaoPage(),
                        ),
                  );
                },
              ),
              ListTile(
                title: const Text('Lista de Exercícios',
                    style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.list_alt, color: Colors.lime),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseList(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Lista de Alimentos',
                    style: TextStyle(fontSize: 16.0)),
                leading:
                    const Icon(Icons.restaurant_menu, color: Colors.orange),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlimentacaoSaudavel(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Suporte', style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.help, color: Colors.brown),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Configurações',
                    style: TextStyle(fontSize: 16.0)),
                leading: const Icon(Icons.settings, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfiguracoesPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100.0,
                    width: 200.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.blue], // Cores do degradê
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "FitLife",
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 64,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    CustomCard(
                      color: Colors.blue, // Defina a cor de fundo aqui
                      title: 'Informações Pessoais',
                      icon: Icons.person,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfoForm(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      color: Colors.green, // Defina a cor de fundo aqui
                      title: 'Plano de Treino',
                      icon: Icons.fitness_center,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlanoTreinoPage(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      color: Colors.red, // Defina a cor de fundo aqui
                      title: 'Plano de Dieta',
                      icon: Icons.food_bank,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Diet() //PlanoAlimentacaoPage(),
                              ),
                        );
                      },
                    ),
                    CustomCard(
                      color: Colors.lime, // Defina a cor de fundo aqui
                      title: 'Lista de Exercícios',
                      icon: Icons.list_alt,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseList(),
                          ),
                        );
                      },
                    ),
                    CustomCard(
                      color: Colors.orange, // Defina a cor de fundo aqui
                      title: 'Alimentos Saudáveis',
                      icon: Icons.restaurant_menu,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlimentacaoSaudavel()),
                        );
                      },
                    ),
                    CustomCard(
                      color: Colors.grey, // Defina a cor de fundo aqui
                      title: 'Configurações',
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfiguracoesPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color; // Adicionamos a propriedade de cor aqui

  const CustomCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color, // Passamos a cor como parâmetro
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: color, // Usamos a cor fornecida no fundo do Card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
