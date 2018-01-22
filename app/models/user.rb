class User < ApplicationRecord
  #用户数据的一些验证函数
###########################################################
  before_save :downcase_email
  #在Users controller中，在create动作执行前做的动作
  #在注册成功之前生成激活摘要,通过邮箱验证激活
  before_create :create_activation_digest

  has_many :microposts,dependent: :destroy

  #存取器，用于读写类中的实例变量
  attr_accessor :remember_token, :activation_token 

  validates :name, presence: true, length: { maximum:50 }

  has_secure_password

  #有效的邮箱正则表达式
  #\-.指连接符和点号
  VALID_EMAIL_REGEX = Regexp.new( /
                                            \A #匹配开头
                                              [\w+\-.]+ # 一个以上英文字母和数字，还有-  .符号
                                             @  
                                            [a-z\d\-.]+ # 一个以上a-z，0-9，- .符号
                                            \. # 匹配.
                                            [a-z]+ # 一个以上a-z
                                            \z # 匹配结尾\Z如果结尾是换行符则匹配换行符前一个字符
                                            /ix ) # 忽略英文字母大小写/
                                                   #忽略空白字符和后面的字符选项

  validates :email, presence: true, length: { maximum:255 },
	           format: { with: VALID_EMAIL_REGEX },
	           uniqueness: { case_sensitive: false }

  validates :password,presence: true,length: { minimum: 6 },
                           allow_nil: true
#############################################################
    # 如果指定的令牌和摘要匹配，返回true
    # remember_token和activation_token验证
    def authenticated?(attribute,token)
      #send是动态语言，根据不同参数返回值
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      #is_password?方法，用于对token加密后与数据库中的进行比较
      BCrypt::Password.new(digest).is_password?(token) 
    end


     #激活账户
    def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at,Time.zone.now)
    end
    

    #为了持久保存会话，在数据库中记住用户
    def remember
      #使用 self 的目的是确保把值赋给用户的 remember_token 属性
      self.remember_token=User.new_token
      update_attribute(:remember_digest,
                                             User.digest(remember_token))
    end


    #发送激活邮件
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end


    #实现动态流
    def feed
      Micropost.where("user_id=?",id)
    end


     # 忘记用户
    def forget
      update_attribute(:remember_digest,nil)
    end
############################################################
  private
  
  # 返回指定字符串的哈希摘要 
  def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? 
                   BCrypt::Engine::MIN_COST :
                  BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost) 
    end

  
    # 返回一个urlsafe_base64随机令牌 
    def User.new_token #定义为一个类的方法
      #ruby随机函数库，产生base64 urlsafe随机函数
      #a-z，A-Z，0-9，-,_.
      SecureRandom.urlsafe_base64   
    end


    #邮箱地址转为小写
    def downcase_email
      self.email=email.downcase
    end


     #创建并赋予激活令牌和摘要
    def create_activation_digest
    #返回一个随机令牌
      self.activation_token=User.new_token
      self.activation_digest=User.digest(activation_token)
    end
end
