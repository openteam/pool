module ElFinder
  class Command::UploadFiles < ElFinder::Command
    register_in_connector :upload

    class Arguments < Command::Arguments
      attr_accessor :target, :upload
      validates_presence_of :target
      validates :entry, :is_a_directory => true
    end

    class Result < Command::Result
       def added
         execute_command
       end
    end

    protected
      def execute_command
        arguments.upload.map{|file| el_root.el_entry(FileEntry.create!(:parent => arguments.entry.entry, :file => file))}
      end
  end
end
