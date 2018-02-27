module Authenticable
 def current_user
   # Se não estiver setado o current_user, buscamos no banco
   @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
 end


   def authenticate_with_token!
     render json: { errors: 'Unauthorized access'}, status: 401 unless current_user.present?
   end

   def user_logged_in?
     current_user.present?
   end
end
