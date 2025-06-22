import 'package:flutter_dotenv/flutter_dotenv.dart';

const kProdEnvAppName = 'PROD_APP_NAME';
const kDevEnvAppname = 'DEV_APP_NAME';

const kProdBaseUrl = 'PROD_BASE_URL';
const kDevBaseUrl = 'DEV_BASE_URL';

const kEnv = "ENVIRONMENT";

const kChatbotAPIKey = "OPEN_API_KEY";
const kChatbotAssistantId = "ASSISTANT_ID";

class EnvHelper {
  static bool get isProd {
    return dotenv.env[kEnv] == "prod";
  }

  static String get appName {
    if (isProd) {
      return dotenv.env[kProdEnvAppName] ?? "";
    } else {
      return dotenv.env[kDevEnvAppname] ?? "";
    }
  }

  static String get baseUrl {
    if (isProd) {
      return dotenv.env[kProdBaseUrl] ?? "";
    } else {
      return dotenv.env[kDevBaseUrl] ?? "";
    }
  }

  static String get env {
    if (isProd) {
      return "PROD";
    } else {
      return "DEV";
    }
  }

  static String get openaiKey {
    return dotenv.env[kChatbotAPIKey] ?? "";
  }

  static String get assistantId {
    return dotenv.env[kChatbotAssistantId] ?? "";
  }
}
