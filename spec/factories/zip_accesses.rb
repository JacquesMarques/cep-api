FactoryBot.define do
  factory :zip_access do
    zipcode { '12345678' }
    state { 'GO' }
    city { 'Goiânia' }
    neighborhood { 'Centro' }
    street { 'Av Goiás' }
    user
  end
end
