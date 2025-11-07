# 🔒 Configurações Firebase para Perfil - GUIA SEGURO

## ⚠️ IMPORTANTE: Antes de Fazer Qualquer Alteração

### PASSO 0: VERIFICAR REGRAS ATUAIS

**NÃO substitua as regras sem verificar primeiro!**

1. Acesse o **Firebase Console**: https://console.firebase.google.com
2. Selecione seu projeto **vencceja**
3. Vá em **Firestore Database** → **Regras**
4. **COPIE AS REGRAS ATUAIS** para um arquivo de backup
5. Leia o que já existe antes de fazer alterações

---

## 📋 OPÇÃO 1: ADICIONAR REGRAS (RECOMENDADO - Mais Seguro)

Se você já tem regras funcionando, **ADICIONE** as novas regras junto com as existentes:

### Para Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ===== SUAS REGRAS EXISTENTES FICAM AQUI =====
    // (mantenha tudo que já existe acima)
    
    // ===== ADICIONE ESTAS NOVAS REGRAS PARA PERFIL =====
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

### Para Storage:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // ===== SUAS REGRAS EXISTENTES FICAM AQUI =====
    // (mantenha tudo que já existe acima)
    
    // ===== ADICIONE ESTAS NOVAS REGRAS PARA FOTOS =====
    // Fotos de perfil: usuário pode fazer upload/delete apenas da própria foto
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
  }
}
```

---

## 🔄 OPÇÃO 2: SUBSTITUIR REGRAS (Se Você Sabe o Que Está Fazendo)

**SÓ FAÇA ISSO SE:**
- Você não tem regras importantes já configuradas
- Você entende o que cada regra faz
- Você fez backup das regras antigas

### Se você substituir, use estas regras COMPLETAS:

**Firestore:**
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
    
    // Se você tiver outras coleções, adicione aqui
    // Exemplo: match /outras_colecoes/{docId} { ... }
  }
}
```

**Storage:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Fotos de perfil: usuário pode fazer upload/delete apenas da própria foto
    match /profile_photos/{userId}.jpg {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Permitir leitura de outras imagens (ajuste conforme necessário)
    match /{allPaths=**} {
      allow read: if request.auth != null;
    }
  }
}
```

---

## ✅ COMO FAZER DE FORMA SEGURA (PASSO A PASSO)

### Firestore Rules:

1. **Acesse**: Firebase Console → Firestore Database → Regras
2. **Veja as regras atuais** (copie para backup se quiser)
3. **Se você não tem regras ou tem apenas regras padrão**, use a OPÇÃO 2 (substituir)
4. **Se você já tem regras personalizadas**, use a OPÇÃO 1 (adicionar)
5. **Clique em "Publicar"**
6. **Teste**: Tente criar um perfil e verificar se funcionou

### Storage Rules:

1. **Acesse**: Firebase Console → Storage → Regras
2. **Veja as regras atuais** (copie para backup se quiser)
3. **Se você não tem regras ou tem apenas regras padrão**, use a OPÇÃO 2 (substituir)
4. **Se você já tem regras personalizadas**, use a OPÇÃO 1 (adicionar)
5. **Clique em "Publicar"**
6. **Teste**: Tente fazer upload de uma foto de perfil

---

## 🧪 TESTAR DEPOIS DE CONFIGURAR

1. **No app**, crie uma conta ou faça login
2. **Vá para o perfil** e tente:
   - Editar o nome → Deve salvar no Firestore
   - Fazer upload de foto → Deve salvar no Storage
   - Ver seus dados → Deve carregar do Firestore

3. **No Firebase Console**, verifique:
   - **Firestore**: `users/{seu-uid}` deve ter sido criado
   - **Storage**: `profile_photos/{seu-uid}.jpg` deve aparecer após upload

---

## ⚠️ SE DER ERRO

1. **Reverta as regras** para as anteriores (faça backup primeiro!)
2. **Verifique** se copiou as regras corretamente
3. **Certifique-se** que o usuário está autenticado no Firebase Auth
4. **Confira** se o projeto Firebase está correto

---

## 📝 RESUMO

- **SE JÁ TEM REGRAS**: Adicione as novas (OPÇÃO 1)
- **SE NÃO TEM REGRAS**: Substitua tudo (OPÇÃO 2)
- **SEMPRE**: Faça backup antes de mudar
- **SEMPRE**: Teste depois de mudar

---

## 💡 DICA

Se você não tem certeza, **comece testando em modo de desenvolvimento**:
- No Firebase Console, você pode configurar regras temporárias mais permissivas
- Teste tudo funcionando
- Depois ajuste para as regras de produção mais restritivas


