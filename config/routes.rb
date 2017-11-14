require 'dynamic_router'
Rails.application.routes.draw do

  use_doorkeeper
  get '', to: redirect("/#{I18n.locale}")

  # redsys MerchantURL
  post '/orders/callback/redsys', to: 'orders#callback_redsys', as: 'orders_callback_redsys'

  namespace :api do
    scope :v1 do
      scope :gcm do
        post 'registrars', to: 'v1#gcm_registrate'
        delete 'registrars/:registrar_id', to: 'v1#gcm_unregister'
      end
    end

    namespace :v2 do
      scope :users do
        get 'me', to: 'users#show'
      end
    end
  end

  scope "/(:locale)", locale: /es|ca|eu/ do

    get '/user/:id', to: 'open_id#user', as: "open_id_user"
    get '/user/xrds', to: 'open_id#xrds', as: "open_id_xrds"

    get '/countvotes/:election_id', to: 'page#count_votes', as: 'page_count_votes'

    get '/votacio/2016/pre-acord-de-govern', to: 'page#votacio_preacord'

    get '/privacy-policy', to: 'page#privacy_policy', as: 'page_privacy_policy'

    get '/responsables-finanzas-legal', to: 'page#town_legal', as: 'town_legal'

    get '/listas-autonomicas', to: 'page#list_register', as: 'list_register'
    get '/avales-candidaturas-barcelona', to: 'page#avales_barcelona', as: 'avales_barcelona'
    get '/primarias-andalucia', to: 'page#primarias_andalucia', as: 'primarias_andalucia'
    get '/listas-primarias-andaluzas', to: 'page#listas_primarias_andaluzas', as: 'listas_primarias_andaluzas'

    get :notices, to: 'notice#index', as: 'notices'

    get '/vote/create/:election_id', to: 'vote#create', as: :create_vote
    get '/vote/create_token/:election_id', to: 'vote#create_token', as: :create_token_vote
    get '/vote/check/:election_id', to: 'vote#check', as: :check_vote

    get '/vote/sms_check/:election_id', to: 'vote#sms_check', as: :sms_check_vote
    get '/vote/send_sms_check/:election_id', to: 'vote#send_sms_check', as: :send_sms_check_vote

    devise_for :users, controllers: {
      registrations: 'registrations',
      passwords:     'passwords',
      confirmations: 'confirmations'
    }

    authenticate :user do
      scope :validator do
        scope :sms do
          get :step1, to: 'sms_validator#step1', as: 'sms_validator_step1'
          get :step2, to: 'sms_validator#step2', as: 'sms_validator_step2'
          get :step3, to: 'sms_validator#step3', as: 'sms_validator_step3'
          post :phone, to: 'sms_validator#phone', as: 'sms_validator_phone'
          post :captcha, to: 'sms_validator#captcha', as: 'sms_validator_captcha'
          post :valid, to: 'sms_validator#valid', as: 'sms_validator_valid'
        end
      end

      scope :colabora do
        delete 'baja', to: 'collaborations#destroy', as: 'destroy_collaboration'
        get 'ver', to: 'collaborations#edit', as: 'edit_collaboration'
        get '', to: 'collaborations#new', as: 'new_collaboration'
        get 'confirmar', to: 'collaborations#confirm', as: 'confirm_collaboration'
        post 'crear', to: 'collaborations#create', as: 'create_collaboration'
        post 'modificar', to: 'collaborations#modify', as: 'modify_collaboration'
        get 'OK', to: 'collaborations#OK', as: 'ok_collaboration'
        get 'KO', to: 'collaborations#KO', as: 'ko_collaboration'
      end
    end

    # http://stackoverflow.com/a/8884605/319241
    devise_scope :user do
      get '/registrations/regions/provinces', to: 'registrations#regions_provinces'
      get '/registrations/regions/municipies', to: 'registrations#regions_municipies'
      get '/registrations/vote/municipies', to: 'registrations#vote_municipies'

      authenticated :user do
        root 'tools#index', as: :authenticated_root
        get 'password/new', to: 'legacy_password#new', as: 'new_legacy_password'
        post 'password/update', to: 'legacy_password#update', as: 'update_legacy_password'
        delete 'password/recover', to: 'registrations#recover_and_logout'
      end
      unauthenticated do
        root 'devise/sessions#new', as: :root
      end
    end

    if Rails.application.secrets.features["verification_presencial"]
      scope '/verificadores' do
        get '/', to: 'verification#step1', as: :verification_step1
        get '/nueva', to: 'verification#step2', as: :verification_step2
        get '/confirmar', to: 'verification#step3', as: :verification_step3
        post '/search', to: 'verification#search', as: :verification_search
        post '/confirm', to: 'verification#confirm', as: :verification_confirm
        get '/ok', to: 'verification#result_ok', as: :verification_result_ok
        get '/ko', to: 'verification#result_ko', as: :verification_result_ko
      end
      scope '/verificaciones' do
        get '/', to: 'verification#show', as: :verification_show
      end
    end

    %w(404 422 500).each do |code|
      get code, to: 'errors#show', code: code
    end

    DynamicRouter.load
  end
  # /admin
  ActiveAdmin.routes(self)

end
