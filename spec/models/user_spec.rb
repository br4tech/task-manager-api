require 'rails_helper'

RSpec.describe User, type: :model do

  # Desta forma ocupa mais memoria e o teste fica lento
  # before{  @user = FactoryBot.build(:user)  }
  # it { expect(@user).to respond_to(:email) }
  # it { expect(@user).to respond_to(:name) }
  # it { expect(@user).to respond_to(:password) }
  # it { expect(@user).to respond_to(:password_confirmation) }
  # it { expect(@user).to be_valid }

  # subject = User.new
  # subject{ FactoryBot.build(:user) }

  # subject{build(:user) }
  # it { expect(subject).to respond_to(:email) }
  # it { expect(subject).to be_valid }

  # Os 3 teste são os mesmos teste
  # it { expect(@user).to respond_to(:email) }
  # it { expect(subject).to respond_to(:email) }
  # it { is_expected.to respond_to(:email) }

  # Somente vai instânciar o user quando o mesmo for chamado no it
  let(:user){ build(:user) }
  it { expect(user).to respond_to(:email) }

  # Utilização do shoulda-matchers: contexto agrupador de teste onde se tem algum em comum

  # context 'when name is blank' do
  # Executa todos os teste
  # before(:all){}

  # Executa antes de cada teste
  # before(:each){}
  # before{ user.name = ' '}
  # Se estiver em branco não é valido
  #   it {expect(user).not_to be_valid}
  # end
  #
  # context 'when name is nill' do
  #   before { user.name = nill }
  #   it{ expect(user).not_to be_valid }
  # end

  # it{ expect(user).to validate_presence_of(:name)}
  # it{ is_expect.to validate_presence_of(:name)}
  it{ is_expected.to validate_presence_of(:email)}
  it{ is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity  }
  it{ is_expected.to validate_confirmation_of(:password)}
  it{ is_expected.to allow_value('guilherme.tr.silva@gmail.com').for(:email)}
  it{ is_expected.to validate_uniqueness_of(:auth_token)}

  #Testando um metodo de instância
  describe '#info'  do
     it 'return email and create_at and a Token' do
       user.save!
       allow(Devise).to receive(:friendly_token).and_return('abc1234xyztoken')

       expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abc1234xyztoken")
     end
  end

  describe '#generate_authentication_token!' do
    it 'generates  a unique auth token' do
       allow(Devise).to receive(:friendly_token).and_return('abc1234xyztoken')
       user.generate_authentication_token!

       expect(user.auth_token).to eq('abc1234xyztoken')
    end

    it 'generates another auth token when the current auth token already has been taken' do

          # existing_user = create(:user, auth_token: 'abc123tokenxyz')
          allow(Devise).to receive(:friendly_token).and_return('abc123tokenxyz','abc123tokenxyz','abcXYZ123456789')
          existing_user = create(:user)
          user.generate_authentication_token!

          expect(user.auth_token).not_to eq(existing_user.auth_token)

    end

  end


end
