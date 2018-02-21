module Authenticable
 def current_user
   # Se não estiver setado o current_user, buscamos no banco 
   @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
 end
end
