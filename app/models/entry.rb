class Entry < ActiveRecord::Base
  has_ancestry :cache_depth => true

  scope :directories, where(:type => 'DirectoryEntry')

  validate :valdate_parent

  def duplicate
    Entry.transaction do
      dup.tap do | entry |
        entry.update_attributes! :name => entry.duplicate_name
        copy_descendants_to(entry)
      end
    end
  end

  def full_path
    "#{parent.full_path}/#{name}"
  end

  def file?
    false
  end

  protected

    def copy_descendants_to(entry)
    end

    def duplicate_name
      i = 0
      begin i += 1 end while parent.children.find_by_name(name_of_copy(i))
      name_of_copy(i)
    end

    def valdate_parent
      errors.add :parent, :must_be_a_directory if parent.is_a?(FileEntry)
    end

end
# == Schema Information
#
# Table name: entries
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  name                :string(255)
#  ancestry            :string(255)
#  ancestry_depth      :integer
#  file_uid            :string(255)
#  file_size           :integer
#  file_width          :integer
#  file_height         :integer
#  file_mime_type      :string(255)
#  file_mime_directory :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

