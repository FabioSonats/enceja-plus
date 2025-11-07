# 📋 Configurações Firebase para Perfil do Usuário

## 🔧 PASSO 1: Configurar Regras do Firestore

1. Acesse o **Firebase Console**: https://console.firebase.google.com
2. Selecione seu projeto **vencceja**
3. Vá em **Firestore Database** → **Regras** (Rules)
4. Substitua as regras por:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler e escrever apenas seu próprio perfil
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Progresso do usuário
      match /progress/{progressId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

5. Clique em **Publicar** (Publish)

---

## 📸 PASSO 2: Configurar Regras do Storage (Para Fotos)

1. No Firebase Console, vá em **Storage** → **Regras** (Rules)
2. Substitua as regras por:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Fotos de perfil: usuário pode fazer upload/delete apenas da própria foto
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Permitir leitura pública de imagens (opcional)
    match /{allPaths=**} {
      allow read: if request.auth != null;
    }
  }
}
```

3. Clique em **Publicar** (Publish)

---

## ✅ ESTRUTURA DE DADOS NO FIRESTORE

Após configurar, os dados serão salvos assim:

```
users/
  {userId}/
    - email: "usuario@email.com"
    - displayName: "João Silva"
    - photoURL: "https://..."
    - phone: "+5511999999999"
    - createdAt: Timestamp
    - updatedAt: Timestamp
    
    progress/
      current/
        - subjectProgress: {matematica: 0.75, ...}
        - overallProgress: 0.525
        - totalStudyTime: 145
        - streakDays: 7
        - completedLessons: 28
```

---

## 🎯 VALIDAÇÕES IMPORTANTES

### Firestore
- ✅ Usuário só acessa seu próprio documento (`uid == userId`)
- ✅ Apenas usuários autenticados podem ler/escrever
- ✅ Progresso protegido da mesma forma

### Storage
- ✅ Usuário só faz upload da própria foto
- ✅ Qualquer usuário autenticado pode ver fotos (para exibição)
- ✅ Apenas o dono pode modificar/deletar

---

## ⚠️ IMPORTANTE

Essas regras são para **desenvolvimento**. Para produção, considere:
- Limitar tamanho de upload
- Validar tipos de arquivo
- Adicionar rate limiting
- Revisar permissões de leitura

---

## 🧪 TESTAR

Após configurar, teste:
1. Criar perfil → Verifica se documento é criado em `users/{uid}`
2. Fazer upload de foto → Verifica se aparece em `Storage/profile_photos/`
3. Editar nome → Verifica se `displayName` é atualizado
4. Tentar acessar perfil de outro usuário → Deve ser negado


