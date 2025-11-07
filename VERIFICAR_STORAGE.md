# ✅ Verificação do Firebase Storage

## 🔍 Como verificar se Storage está funcionando:

### 1. **Teste Manual no Firebase Console**
   - Firebase Console → Storage → **Arquivos**
   - Clique em **"Fazer upload de arquivo"**
   - Tente fazer upload de uma imagem pequena
   - **Se funcionar** → Storage está OK ✅
   - **Se der erro** → Precisa habilitar/upgrade ❌

### 2. **Verificar Regras**
   - Firebase Console → Storage → **Regras**
   - Certifique-se de que as regras estão **publicadas** (botão "Publicar")
   - As regras devem permitir:
     ```javascript
     match /profile_photos/{userId}/{fileName} {
       allow read: if request.auth != null;
       allow write: if request.auth != null && request.auth.uid == userId;
     }
     ```

### 3. **Verificar Plano**
   - Firebase Console → Visão Geral → **Plano**
   - Se estiver em **Spark (Gratuito)**:
     - Storage pode ter limitações
     - Pode precisar fazer upgrade para **Blaze (Pay-as-you-go)**
   - Se estiver em **Blaze**:
     - Storage deve funcionar normalmente ✅

### 4. **Testar no App**
   - Faça login no app
   - Vá para Perfil
   - Tente fazer upload de uma foto
   - **Observe o console** para ver os logs detalhados:
     - `📸 Iniciando upload...`
     - `📊 Progresso: X%`
     - `✅ Upload concluído!` ou `❌ Erro...`

---

## 🐛 Se ainda estiver dando erro:

### Erro: `permission-denied`
**Solução:** Verifique se as regras do Storage estão publicadas corretamente.

### Erro: `canceled` ou `timeout`
**Possíveis causas:**
1. Conexão lenta
2. Arquivo muito grande (tente uma imagem menor)
3. Storage não respondendo

**Solução:** Tente novamente com uma imagem menor (< 2MB).

### Erro: `unauthenticated`
**Solução:** Faça login novamente no app.

### Erro: `bucket not found` ou `Storage não configurado`
**Solução:** 
1. Verifique se Storage está habilitado no Firebase Console
2. Se necessário, faça upgrade do plano Spark → Blaze

---

## 📝 Logs que você deve ver no console:

### ✅ **Sucesso:**
```
📸 Iniciando upload da foto para: profile_photos/{userId}/photo.jpg
📁 Referência criada: profile_photos/{userId}/photo.jpg
⏳ Aguardando conclusão do upload...
📊 Progresso: 25.0% (50000/200000 bytes)
📊 Progresso: 50.0% (100000/200000 bytes)
📊 Progresso: 100.0% (200000/200000 bytes)
✅ Upload concluído! Bytes enviados: 200000/200000
🔗 Obtendo URL de download...
✅ URL obtida: https://...
```

### ❌ **Erro:**
```
📸 Iniciando upload da foto para: profile_photos/{userId}/photo.jpg
📁 Referência criada: profile_photos/{userId}/photo.jpg
⏳ Aguardando conclusão do upload...
❌ Erro detectado durante upload: ...
🔥 Erro do Firebase: permission-denied - ...
```

---

## 🎯 Próximos Passos:

1. **Teste o upload manual no Firebase Console** primeiro
2. **Se funcionar**, teste no app
3. **Se não funcionar**, verifique o plano e as regras
4. **Envie os logs do console** se ainda tiver problemas

