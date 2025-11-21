/// Validações para formulários de autenticação

class Validators {
  /// Validação de email
  /// 
  /// Regras:
  /// - Não pode estar vazio
  /// - Deve ter formato válido com @ e domínio
  /// 
  /// Regex: ^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite seu e-mail";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "E-mail inválido";
    }

    return null;
  }

  /// Validação de senha para cadastro
  /// 
  /// Regras:
  /// - Mínimo de 8 caracteres
  /// - Pelo menos 1 letra maiúscula
  /// - Pelo menos 1 letra minúscula
  /// - Pelo menos 1 número
  /// - Pelo menos 1 símbolo (@$!%*?&)
  /// 
  /// Regex: ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$
  static String? validatePasswordSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite sua senha";
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return "A senha deve conter:\n"
          "• 8+ caracteres\n"
          "• Letra maiúscula\n"
          "• Letra minúscula\n"
          "• Número\n"
          "• Símbolo (@\$!%*?&)";
    }

    return null;
  }

  /// Validação de senha para login (mais simples)
  /// 
  /// Regras:
  /// - Apenas verificar que não está vazia
  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return "Digite sua senha";
    }
    return null;
  }
}

