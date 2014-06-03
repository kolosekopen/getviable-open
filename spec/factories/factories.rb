FactoryGirl.define do
  factory :role do
    name "admin"
  end

  factory :idea do
    sequence(:title) {|n| "SuperTitle#{n}"}
    description "One glass that you can't look Through"
    user
    response_set
  end

  factory :package do
    idea
    code
    package 0
    paid false
    reserved_package nil
    promo_code nil
  end

  factory :custom_email do
    user
    original_email 'vuk.gladni@gmail.com'
    custom_email 'vuk.gladni@gmail.com'
  end

  factory :promo do
    code '123abc'
    discount 10 # % <percent>
    expires Time.zone.now + 1.hour
    used false
  end

  factory :question do
    text "What do you think?"
    sequence(:display_order) { |n| "#{n}" }
  end

  factory :ideas_users do
    user
    idea
    role_id 1
  end

  factory :user do
    sequence(:email) { |n| "john#{n}@doe.com" }
    password "password"
    password_confirmation "password"
    name 'John Doe'

    factory :user_with_ideas do
      # posts_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      ignore do
        idea_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the idea
      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:idea, evaluator.idea_count, :user_id => user.id)
      end
    end

  end

  factory :survey_section do
    sequence(:title) { |n| "SurveySection#{n}" }
    description "This section can define your idea"
    sequence(:display_order) { |n| "#{n}" }


    factory :section_with_questions do
      # posts_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      ignore do
        question_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the idea
      after(:create) do |section, evaluator|
        FactoryGirl.create_list(:question, evaluator.question_count, :survey_section_id => section.id, :display_order => 1)
      end
    end
  end

  factory :stage do
    sequence(:title) { |n| "Stage#{n}" }

    factory :stage_with_sections do
      # posts_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      ignore do
        step_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the idea
      after(:create) do |stage, evaluator|
        FactoryGirl.create_list(:section_with_questions, evaluator.step_count, :stage_id => stage.id)
      end
    end
  end

  factory :response do
    response_set_id 1
    question_id 1
    answer_id 1
    string_value "Answer"
  end

  factory :response_set do
    survey_id 1
    sequence(:access_code) { |n| "Code#{n}" }
    sequence(:api_id) { |n| "Api#{n}" }
    idea_id 1
  end
  
  factory :activity do
    survey_section_id 1
    idea_id 1
    content "Questions and Answers"
    event_type 10
  end

  factory :person do
    user_id 1
    first_name "John"
    last_name "Doe"
    date_of_birth 1990-02-15
    mobile_phone "+61 3 9658 9658"
    other_phone "+61 3 9658 9658"
    address "Collins Street"
    city "Melbourne"
    state "Australia"
  end


  factory :invitation do
    association :invitable, :factory => :idea
    user_id 1
    invitee_email "test@joe.com"
    invitee_role_id IdeasUsers::BUSINESS
    active true
  end
  
  factory :group do
    title "Serbia"
  end

  factory :expert_request do
    support_type 1
    subject "My questions"
    problem "This is my problem"
    terms_conditions 1
    survey_section_id 1
  end
    
  factory :order do
      user_id 1
      express_token "PayPalexpressToken"
      express_payer_id "String"
      first_name "NameOfMine"
      last_name "LastOfName"
      ip_address "127.0.0.1"
      association :package, :factory => :package
      package_code "bonus"
  end

  factory :answer do
    text "sometitle"
  end

  factory :question_group do
    text "sometitle"
  end
end
