import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Firebase {
  late String _apiKey;
  late String _clientId;
  late String authUrl;
  late String _authToken;
  late String _clientSecret;

  Firebase.init(
      {required String apiKey,
      required String clientId,
      required String clientSecret}) {
    _apiKey = apiKey;
    _clientId = clientId;
    _clientSecret = clientSecret;
    authUrl =
        "https://accounts.google.com/o/oauth2/v2/auth?client_id=$_clientId&redirect_uri=http://localhost:5000&scope=https://www.googleapis.com/auth/userinfo.profile&response_type=code";
  }

  Future<void> handleGetRequest(HttpRequest req,
      Future<dynamic> Function({bool force}) closeServer) async {
    HttpResponse res = req.response;

    var data = req.uri.queryParameters;
    _authToken = data["code"] == null ? "" : data["code"] as String;

    res.write('Received request GET: $_authToken');
    print('Received request GET: $_authToken');
    if (_authToken != "") {
      File("data.txt").writeAsString(_authToken);
      closeServer();
    }

    res.close();
  }

  Future<void> _ServeAt(InternetAddress address, {int port = 5000}) async {
    var server = await HttpServer.bind(address, port);
    var closeServer = server.close;
    await server.forEach((HttpRequest request) async {
      switch (request.method) {
        case 'GET':
         await handleGetRequest(request, closeServer);
          //closeServer();
          break;
        // case 'POST': We handle only get request so No Post case
        //   handlePostRequest(request);
        default:
          print("Unknown Request");
      }
    });

    //return {};
  }

  String _encodeMap(Map data) {
    return data.keys
        .map((key) =>
            "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}")
        .join("&");
  }

  Future<void> auth() async {
    //launch the url [Google user consent page] in browser to get user decision
    //we use url_launcher package for launching url
    if (!await launchUrl(Uri.parse(authUrl),
        mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $authUrl';
    }
    await _ServeAt(InternetAddress.anyIPv6);

    //String url = "https://oauth2.googleapis.com/token?";
    Map<String, String> parameters = new Map();

    parameters["code"] = _authToken; //auth_code.toString();
    parameters["client_id"] = _clientId;
    parameters["client_secret"] = _clientSecret;
    parameters["redirect_uri"] = "http://localhost:5000";
    parameters["grant_type"] = "authorization_code";
    parameters["access_type"] = "offline";
    var data = _encodeMap(parameters);
    print(parameters);

    var response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'), //Endpoint url for getting acess token
        body: data,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    final Map<String,String> resdata = JsonDecoder().convert(response.body);
    final Map<String,String> reqdata={
      "postBody":"id_token=[GOOGLE_ID_TOKEN]",
      "providerId":"[google.com]",
      "requestUri":"[http://localhost]",
      "returnIdpCredential":"true",
      "returnSecureToken":"true"
    };
    //  http.post(Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=$_apiKey"),headers: {
    //   'Content-Type': 'application/json'
    //  },body: );

//     curl 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=[API_KEY]' \
// -H 'Content-Type: application/json' \
// --data-binary '{"postBody":"id_token=[GOOGLE_ID_TOKEN]&providerId=[google.com]","requestUri":"[http://localhost]","returnIdpCredential":true,"returnSecureToken":true}'

    //resdata['access_token']
    //print();
  }
}




// "rawUserInfo": "{\"iss\":\"https://accounts.google.com\",\"azp\":\"17028056165-lu0t49dvab4r1nhbdcimkocth96ailqg.apps.googleusercontent.com\",\"aud\":\"17028056165-lu0t49dvab4r1nhbdcimkocth96ailqg.apps.googleusercontent.com\",\"sub\":\"104862888125043298103\",\"at_hash\":\"s0uUccI-WKPrhsKKNo_3nw\",\"name\":\"saugat kandel\",\"picture\":\"https://lh3.googleusercontent.com/a/ALm5wu0Yfy9KhrRV_UXVtmaXcrOeikt1qjwQrRELqY9K=s96-c\",\"given_name\":\"saugat\",\"family_name\":\"kandel\",\"locale\":\"en-GB\",\"iat\":1669084511,\"exp\":1669088111}",
//   "isNewUser": true,
//   "kind": "identitytoolkit#VerifyAssertionResponse"
// }
// [x@x-c