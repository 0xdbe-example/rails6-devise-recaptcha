
module Captcha
    extend ActiveSupport::Concern

    def captcha_check_signin
      captcha_check("signin")
    end

    def captcha_check_signup
      captcha_check("signup")
    end

    def captcha_check(action)

        result = verify_recaptcha(action: action, minimum_score: 0.1)
    
        if recaptcha_reply.key?("error-codes")
          Rails.logger.warn("Recaptcha Error: #{recaptcha_reply['error-codes']}")
        end
    
        if recaptcha_reply.key?("score")
          session[:recaptcha_score] = recaptcha_reply['score']
          Rails.logger.warn("Recaptcha score: #{recaptcha_reply['score']}")
        end
    
        return if result
    
        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides reCAPTCHA
        set_minimum_password_length
    
        respond_with_navigational(resource) do
          flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
          render :new
        end
        
    end
end