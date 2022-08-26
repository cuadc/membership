class ConvertPaperTrailYamlToJson < ActiveRecord::Migration[6.1]
  def up
    PaperTrail::Version.where.not(object: nil).find_each do |version|
      version.update_column(:new_object, YAML.load(version.object))
      if version.object_changes
        version.update_column(:new_object_changes, YAML.load(version.object_changes))
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
