# 🔒 Regras Firebase Completas - Copiar e Colar

## 📋 FIRESTORE RULES

Copie e cole estas regras COMPLETAS no Firebase Console → Firestore Database → Regras:

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
    // REGRAS PARA OUTRAS COLEÇÕES
    // ============================================
    // Se você tiver outras coleções no futuro, adicione aqui
    
    // Exemplo para outras coleções (descomente e ajuste conforme necessário):
    // match /outras_colecoes/{docId} {
    //   allow read: if request.auth != null;
    //   allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    // }
    
    // ============================================
    // REGRA PADRÃO (RESTRITIVA)
    // ============================================
    // Bloqueia acesso a qualquer documento não especificado acima
    match /{document=**} {
      allow read, write: if false;
    }
    
  }
}
```

---

## 📸 STORAGE RULES

Copie e cole estas regras COMPLETAS no Firebase Console → Storage → Regras:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // ============================================
    // FOTOS DE PERFIL
    // ============================================
    
    // Fotos de perfil: usuário pode fazer upload/delete apenas da própria foto
    // Qualquer usuário autenticado pode ver (para exibição em perfis)
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // ============================================
    // OUTROS ARQUIVOS
    // ============================================
    // Se você tiver outras pastas de arquivos, adicione aqui
    
    // Exemplo para outras pastas (descomente e ajuste conforme necessário):
    // match /outros_arquivos/{allPaths=**} {
    //   allow read: if request.auth != null;
    //   allow write: if request.auth != null;
    // }
    
    // ============================================
    // REGRA PADRÃO (RESTRITIVA)
    // ============================================
    // Bloqueia acesso a qualquer arquivo não especificado acima
    match /{allPaths=**} {
      allow read, write: if false;
    }
    
  }
}
```

---

## ⚠️ IMPORTANTE

### 🔴 Remover Regra Temporária

A regra que você tinha:
```javascript
allow read, write: if request.time < timestamp.date(2025, 11, 28);
```

**FOI REMOVIDA** das novas regras porque:
- É uma regra temporária/teste
- Pode criar brechas de segurança
- As novas regras já protegem adequadamente com autenticação

**Se você precisar dessa regra temporária por algum motivo**, adicione antes da regra padrão:

```javascript
// REGRA TEMPORÁRIA (REMOVER ANTES DE PRODUÇÃO!)
match /{document=**} {
  allow read, write: if request.time < timestamp.date(2025, 11, 28);
}
```

---

## ✅ COMO APLICAR

### 1. Firestore Rules:
1. Acesse: Firebase Console → Firestore Database → Regras
2. **Delete tudo** que está lá
3. **Cole** as regras de Firestore acima (a primeira caixa de código)
4. Clique em **Publicar**

### 2. Storage Rules:
1. Acesse: Firebase Console → Storage → Regras
2. **Delete tudo** que está lá (ou veja se tem algo importante)
3. **Cole** as regras de Storage acima (a segunda caixa de código)
4. Clique em **Publicar**

---

## 🧪 TESTAR APÓS APLICAR

1. **No app**, faça login
2. **Vá para o perfil** e tente:
   - ✅ Editar nome → Deve funcionar
   - ✅ Adicionar telefone → Deve funcionar
   - ✅ Fazer upload de foto → Deve funcionar
   - ✅ Ver seus dados → Deve carregar

3. **No Firebase Console**, verifique:
   - Firestore → `users/{seu-uid}` existe
   - Storage → `profile_photos/{seu-uid}.jpg` existe (após upload)

---

## 🔒 SEGURANÇA

As regras garantem que:
- ✅ Apenas usuários autenticados podem acessar
- ✅ Cada usuário só acessa seu próprio perfil e progresso
- ✅ Fotos de perfil podem ser vistas por qualquer usuário autenticado (para exibição)
- ✅ Apenas o dono pode modificar/deletar sua foto
- ✅ Qualquer outra coleção/arquivo é bloqueado por padrão

---

## 📝 OBSERVAÇÕES

- Se no futuro você criar novas coleções, adicione as regras antes da linha `match /{document=**}`
- A regra `match /{document=**} { allow read, write: if false; }` bloqueia tudo que não foi especificado
- Isso é mais seguro que deixar aberto


