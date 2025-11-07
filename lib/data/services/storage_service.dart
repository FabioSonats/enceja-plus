import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  // Inicializar Storage com bucket explícito
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'vencceja-e8a9c.firebasestorage.app',
  );
  static const String _profilePhotosPath = 'profile_photos';

  /// Upload de foto de perfil
  Future<String> uploadProfilePhoto({
    required String uid,
    required XFile imageFile,
  }) async {
    try {
      print('📸 Iniciando upload da foto para: profile_photos/$uid/photo.jpg');
      
      // Criar referência do arquivo
      // O Firebase Storage cria automaticamente as pastas quando você faz upload
      // Estrutura: profile_photos/{userId}/photo.jpg
      final ref = _storage
          .ref()
          .child(_profilePhotosPath)
          .child(uid)
          .child('photo.jpg');

      print('📁 Referência criada: ${ref.fullPath}');
      print('ℹ️ O Firebase criará automaticamente a pasta se não existir');

      // Upload do arquivo
      UploadTask uploadTask;
      if (kIsWeb) {
        // Web: usar bytes
        print('🌐 Plataforma: Web - usando bytes');
        final bytes = await imageFile.readAsBytes();
        print('📊 Tamanho do arquivo: ${bytes.length} bytes');
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        // Mobile: usar arquivo local
        print('📱 Plataforma: Mobile - usando arquivo');
        final file = File(imageFile.path);
        if (!await file.exists()) {
          throw 'Arquivo não encontrado: ${imageFile.path}';
        }
        print('📊 Tamanho do arquivo: ${await file.length()} bytes');
        uploadTask = ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      print('⏳ Aguardando conclusão do upload...');

      // Adicionar listener de progresso e erros
      StreamSubscription? progressSubscription;
      String? uploadError;
      
      progressSubscription = uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          if (snapshot.totalBytes > 0) {
            final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            print('📊 Progresso: ${progress.toStringAsFixed(1)}% (${snapshot.bytesTransferred}/${snapshot.totalBytes} bytes)');
          }
          print('   Estado: ${snapshot.state}');
          
          // Capturar erros durante o upload
          if (snapshot.state == TaskState.error) {
            uploadError = 'Erro durante upload (estado: ${snapshot.state})';
            print('❌ Erro detectado durante upload: $uploadError');
          }
        },
        onError: (error) {
          uploadError = error.toString();
          print('❌ Erro no stream de upload: $uploadError');
        },
      );

      // Aguardar conclusão do upload com timeout maior
      TaskSnapshot snapshot;
      try {
        // Aumentar timeout para 60 segundos e melhorar tratamento
        snapshot = await uploadTask.timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            print('⏱️ Timeout após 60 segundos - cancelando upload');
            uploadTask.cancel();
            throw TimeoutException(
              'Upload timeout após 60 segundos',
              const Duration(seconds: 60),
            );
          },
        );
        
        // Verificar se houve erro durante o upload
        if (uploadError != null) {
          throw uploadError!;
        }
      } on FirebaseException catch (e) {
        // Capturar erros específicos do Firebase
        print('🔥 Erro do Firebase: ${e.code} - ${e.message}');
        await progressSubscription.cancel();
        
        String errorMessage;
        switch (e.code) {
          case 'permission-denied':
            errorMessage = 'Permissão negada. Verifique as regras do Storage no Firebase Console.';
            break;
          case 'unauthenticated':
            errorMessage = 'Usuário não autenticado. Faça login novamente.';
            break;
          case 'canceled':
            errorMessage = 'Upload cancelado. Verifique sua conexão e tente novamente.';
            break;
          case 'quota-exceeded':
            errorMessage = 'Quota excedida. Verifique o plano do Firebase.';
            break;
          default:
            errorMessage = 'Erro do Firebase: ${e.code} - ${e.message}';
        }
        throw errorMessage;
      } on TimeoutException {
        await progressSubscription.cancel();
        throw 'Timeout: Upload demorou mais de 60 segundos.\n\nPossíveis causas:\n1. Conexão lenta\n2. Arquivo muito grande\n3. Storage não respondendo\n\nTente novamente ou use uma imagem menor.';
      } catch (e) {
        await progressSubscription.cancel();
        
        // Verificar se é erro de Storage não habilitado
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('bucket') || 
            errorStr.contains('storage') ||
            errorStr.contains('not found') ||
            errorStr.contains('not-found') ||
            errorStr.contains('permission-denied') ||
            errorStr.contains('unauthorized') ||
            errorStr.contains('403') ||
            errorStr.contains('404')) {
          throw 'Storage não configurado ou sem permissão.\n\nSolução:\n1. Verifique se as regras do Storage estão publicadas\n2. Verifique se o Storage está habilitado no Firebase Console\n3. Se necessário, faça upgrade do plano Spark para Blaze';
        }
        rethrow;
      } finally {
        await progressSubscription.cancel();
      }
      
      print('✅ Upload concluído! Bytes enviados: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      print('   Estado final: ${snapshot.state}');
      
      // Obter URL do arquivo
      print('🔗 Obtendo URL de download...');
      final downloadURL = await snapshot.ref.getDownloadURL().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Timeout: Não foi possível obter URL de download';
        },
      );
      
      print('✅ URL obtida: $downloadURL');
      return downloadURL;
    } catch (e, stackTrace) {
      print('❌ Erro detalhado no upload:');
      print('   Tipo: ${e.runtimeType}');
      print('   Mensagem: $e');
      print('   StackTrace: $stackTrace');
      
      // Mensagens de erro mais específicas
      String errorMessage = 'Erro ao fazer upload da foto';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permissão negada. Verifique as regras do Storage.';
      } else if (e.toString().contains('unauthenticated')) {
        errorMessage = 'Usuário não autenticado. Faça login novamente.';
      } else if (e.toString().contains('bucket') || e.toString().contains('Storage')) {
        errorMessage = 'Storage não configurado. Verifique se fez upgrade do plano.';
      } else if (e.toString().contains('Timeout')) {
        errorMessage = 'Upload demorou muito. Verifique sua conexão.';
      } else {
        errorMessage = 'Erro: ${e.toString()}';
      }
      
      throw errorMessage;
    }
  }

  /// Deletar foto de perfil antiga
  Future<void> deleteProfilePhoto(String uid) async {
    try {
      final ref = _storage
          .ref()
          .child(_profilePhotosPath)
          .child(uid)
          .child('photo.jpg');
      
      await ref.delete();
    } catch (e) {
      // Ignorar erro se arquivo não existir
      print('Erro ao deletar foto (pode não existir): $e');
    }
  }

  /// Obter URL da foto de perfil
  Future<String?> getProfilePhotoURL(String uid) async {
    try {
      final ref = _storage
          .ref()
          .child(_profilePhotosPath)
          .child(uid)
          .child('photo.jpg');
      
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Foto não existe ou erro
      return null;
    }
  }
}

