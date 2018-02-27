require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task){ build(:task)}
  context 'when is new' do
    # Verifica se o valor do campo done é verdadeiro/falso, qualquer campo que for boleano be_campo_boleano
     it{ expect(task).not_to be_done }
  end
  # Verifica se o relacionamento existe
   it{ is_expected.to belong_to(:user) }

   it{ is_expected.to validate_presence_of :title }
   it{ is_expected.to validate_presence_of :user_id }

  # Verifica se existe os campos para ver se o campo não foi removido
   it{ is_expected.to respond_to(:title)}
   it{ is_expected.to respond_to(:description)}
   it{ is_expected.to respond_to(:deadline)}
   it{ is_expected.to respond_to(:done)}
   it{ is_expected.to respond_to(:user_id)}

end
