import 'package:local_auth/local_auth.dart';

class AuthServices{

  final LocalAuthentication localAuth = LocalAuthentication(); 

  Future<bool> authenticateLocally() async{
    bool isAuthenticated = false;
    try{
      isAuthenticated = await localAuth.authenticate(localizedReason: "Please authenticate to continue",
          options: AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          )
      );
    }catch(ex){
      print('Error : $ex');
    }
    
    return isAuthenticated;
  }
}