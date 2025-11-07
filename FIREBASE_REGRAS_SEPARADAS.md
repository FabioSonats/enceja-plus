# 🔒 Regras Firebase - SEPARADAS POR SERVIÇO

## ⚠️ IMPORTANTE: São DOIS lugares diferentes!

Você precisa colar cada regra no lugar correto:
- **Firestore Rules** → Vai em **Firestore Database → Regras**
- **Storage Rules** → Vai em **Storage → Regras**

**NÃO cole tudo junto em um só lugar!**

---

## 📋 PASSO 1: FIRESTORE RULES

1. No Firebase Console, vá em: **Firestore Database → Regras**
2. **Delete tudo** que está lá
3. **Cole APENAS isto** (sem as regras de Storage):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ============================================
    // REGRAS DE PERFIL E PROGRESSO DO USUÁRIO
    // ============================================
    
    // Usuários podem ler e escrever apenas seu próprio perfil
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Progresso do usuário (subcoleção dentro de users)
      match /progress/{progressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // ============================================
    // REGRA PADRÃO (BLOQUEIA TUDO MAIS)
    // ============================================
    match /{document=**} {
      allow read, write: if false;
    }
    
  }
}
```

4. Clique em **Publicar**

---

## 📸 PASSO 2: STORAGE RULES

1. No Firebase Console, vá em: **Storage → Regras** (é outra aba/seção!)
2. **Delete tudo** que está lá
3. **Cole APENAS isto** (sem as regras de Firestore):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // ============================================
    // FOTOS DE PERFIL
    // ============================================
    
    // Fotos de perfil: qualquer usuário autenticado pode ver
    // Apenas o dono pode fazer upload/delete
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // ============================================
    // REGRA PADRÃO (BLOQUEIA TUDO MAIS)
    // ============================================
    match /{allPaths=**} {
      allow read, write: if false;
    }
    
  }
}
```

4. Clique em **Publicar**

---

## ✅ VERIFICAÇÃO

Depois de aplicar:

1. **Firestore Database → Regras**: Deve mostrar apenas `service cloud.firestore { ... }`
2. **Storage → Regras**: Deve mostrar apenas `service firebase.storage { ... }`

Se você colocar Storage dentro de Firestore (ou vice-versa), dará erro!

---

## 🎯 RESUMO RÁPIDO

- **Firestore Rules** → Cole no lugar de **Firestore Database → Regras**
- **Storage Rules** → Cole no lugar de **Storage → Regras**
- **São serviços separados!** Não misture!


