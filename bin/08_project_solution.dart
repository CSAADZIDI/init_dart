// 06_project.dart
// 🎯 Mini-projet : flux de login en console avec classes + async
//
// Objectifs :
// - Lire des entrées utilisateur (stdin / stdout.write)
// - Utiliser des Futures avec async/await pour simuler du réseau
// - Structurer le code en "services" + "modèles"
// - Manipuler une logique métier simple (authentification, profil)
//
// Pour exécuter le code : dart run 06_project.dart

/*
  🔹 Contexte

  Dans une vraie app, la vérification des identifiants et la récupération
  de profil se font côté serveur (HTTP, base de données). Ici, on simule
  ces appels avec Future.delayed pour rendre visibles les notions asynchrones.

  Architecture (simplifiée) :
    main()            → orchestration du flux console
    AuthService       → service d’authentification (vérifie user/pass)
    UserRepository    → service d’accès aux données utilisateur
    UserProfile       → modèle de données (DTO)
*/
import 'dart:io';
import 'dart:async';

Future<void> main() async {
  print("=== Login Simulation ===");

  final auth = AuthService();

  // --- 1) Tentatives de connexion ---
  int attempts = 0;
  const maxAttempts = 3;
  bool authenticated = false;
  String? username;

  while (attempts < maxAttempts && !authenticated) {
    stdout.write("Enter username: ");
    username = stdin.readLineSync()?.trim();

    stdout.write("Enter password: ");
    final password = stdin.readLineSync();

    if (username == null || username.isEmpty || password == null || password.isEmpty) {
      print("Username/password required.\n");
      continue;
    }

    print("Checking credentials...");
    final ok = await auth.checkCredentials(username, password);

    if (ok) {
      authenticated = true;
      print("✅ Login successful!\n");
    } else {
      attempts++;
      print("❌ Invalid credentials. Attempts left: ${maxAttempts - attempts}\n");
      if (attempts == maxAttempts) {
        print("Too many failed attempts. Access denied.");
        exit(1);
      }
    }
  }

  // --- 2) Récupération du profil ---
  final repo = UserRepository();
  print("Fetching profile...");
  final profile = await repo.fetchProfile(username!);
  print("Welcome, ${profile.displayName}! Role=${profile.role}\n");

  // --- 3) Menu principal ---
  String? choice;
  do {
    print("=== Menu ===");
    print("[1] Voir profil");
    print("[2] Changer rôle");
    print("[3] Quitter");
    stdout.write("Choix: ");
    choice = stdin.readLineSync();

    switch (choice) {
      case "1":
        print("👤 Profil: ${profile.displayName}, rôle actuel: ${profile.role}\n");
        break;
      case "2":
        stdout.write("Entrez le nouveau rôle: ");
        final newRole = stdin.readLineSync();
        if (newRole != null && newRole.isNotEmpty) {
          profile.role = newRole;
          print("✅ Rôle changé en: ${profile.role}\n");
        } else {
          print("⚠️ Rôle invalide.\n");
        }
        break;
      case "3":
        print("👋 Au revoir, ${profile.displayName}!");
        break;
      default:
        print("Option invalide.\n");
    }
  } while (choice != "3");
}

// ---------------------------------------------------------------------------
// 🧩 Services & Modèles
// ---------------------------------------------------------------------------

class AuthService {
  // Map d'utilisateurs (username → password)
  final Map<String, String> users = {
    "alice": "secret",
    "bob": "1234",
    "charlie": "pass",
  };

  Future<bool> checkCredentials(String user, String pass) async {
    await Future.delayed(Duration(seconds: 1)); // latence simulée
    return users[user] == pass;
  }
}

class UserRepository {
  Future<UserProfile> fetchProfile(String username) async {
    await Future.delayed(Duration(seconds: 1));
    final display = username.isEmpty
        ? "(unknown)"
        : username[0].toUpperCase() + username.substring(1);
    return UserProfile(displayName: display, role: "student");
  }
}

class UserProfile {
  final String displayName;
  String role;
  UserProfile({required this.displayName, required this.role});

  @override
  String toString() => "UserProfile(displayName=$displayName, role=$role)";
}
