bool isOtpError(String msg) => msg.contains("Account not verified");

bool isInvalidCredentials(String msg) => msg.contains("Invalid credentials");

bool isSystemError(String msg) =>
    msg.isNotEmpty && !isOtpError(msg) && !isInvalidCredentials(msg);
