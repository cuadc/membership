class RenameUcamRavenProviderAccountsField < ActiveRecord::Migration[7.0]
  def up
    ProviderAccount.where(provider: "ucamraven").update_all(provider: "ucam-raven")
  end

  def down
    ProviderAccount.where(provider: "ucam-raven").update_all(provider: "ucamraven")
  end
end
