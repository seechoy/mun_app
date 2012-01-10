require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :alias, :email, :password, :password_confirmation

  has_many :conferences, :dependent => :destroy
  has_many :attendances, :dependent => :destroy
  has_many :attending, :through => :attendances, :source => :conference

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :alias, :presence => true,
                    :length => { :maximum => 32 },
                    :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..32 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def attending?(conference)
    attendances.find_by_conference_id(conference)
  end

  def attend!(conference)
    attendances.create!(:conference_id => conference.id)
  end

  def unattend!(conference)
    attendances.find_by_conference_id(conference).destroy
  end

  private

    def encrypt_password
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
