module Generate

  class Test < BaseTemplate

    @tests_path

    def initialize(options, config)
      super
      @tests_path = generate_tests_path
      options[:generate_tests] = true
      folder_name = @tests_path.split(File::SEPARATOR)[-1]
      options[:class_name] = options[:name].dup
      options[:name] = folder_name
    end

    def generate_tests_path
      sources_dir = self.config['sources_dir']
      source_path = `find ./#{sources_dir} -name "#{options[:name]}.m"`
      source_path["./#{sources_dir}/"] = ''
      source_path["/#{options[:name]}.m"] = ''
      source_path.gsub!(/\s+/, ' ').strip!
      source_path
    end

    def tests_path
      @tests_path.split(File::SEPARATOR)[0..-2].join(File::SEPARATOR)
    end

    def assembly?
      options[:class_name].downcase.include? 'assembly'
    end

    def template_test_files
      if assembly?
        [
            {
                'name' => 'Tests.m', 'path' => 'Tests/tests_assembly.m.liquid',
                'custom_name' => "#{options[:class_name]}Tests.m"
            }
        ]
      else
        [
            {   'name' => 'Tests.m', 'path' => 'Tests/tests.m.liquid',
                'custom_name' => "#{options[:class_name]}Tests.m"
            },
            {
                'name' => 'Testable.h', 'path' => 'Tests/testable_category.h.liquid',
                'custom_name' => "#{options[:class_name]}_Testable.h"
            }
        ]
      end
    end


    def template_parameters
      { class_name: options[:class_name]}
    end

  end

end