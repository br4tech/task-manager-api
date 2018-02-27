class Api::V1::SessionsController < ApplicationController

  def create
     user =  User.find_by(email:sessions_params[:email])
     # byebug
     if user && user.valid_password?(sessions_params[:password])
       # byebug
       # sign_in helper do devise que "loga" o usuario no sistema
       # store: false, quando não queremos gravar a sessão, cada requisição é unica na api
        sign_in user, store: false

        #Salvar usuario no banco com um novo token
        user.generate_authentication_token!
        user.save

       render json: user, status: 200
     else
       render json: {errors: 'Invalid password or email'}, status: 401
     end
  end
  
 def destroy
   user = User.find_by(auth_token: params[:id])
   user.generate_authentication_token!
   user.save

   head 204
 end


  private
    def sessions_params
     # params.require(:sessions).permit(:email, :password)
     params.require(:sessions).permit(:email, :password)
    end

end
