class PasswordEncryption
  def self.encrypt_master_password(password)
    `mvn --encrypt-master-password #{password}`
  end

  def self.encrypt_password(password)
    `mvn --encrypt-password #{password}`
  end
end