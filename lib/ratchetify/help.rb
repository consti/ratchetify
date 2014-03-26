module Capistrano
  class CLI
    module Help

      def task_list(config, pattern = true) #:nodoc:
        tool_output = options[:tool]

        if pattern.is_a?(String)
          tasks = config.task_list(:all).select {|t| t.fully_qualified_name =~ /#{pattern}/}
        end
        if tasks.nil? || tasks.length == 0
          warn "Pattern '#{pattern}' not found. Listing all tasks.\n\n" if !tool_output && !pattern.is_a?(TrueClass)
          tasks = config.task_list(:all)
        end

        if tasks.empty?
          warn "There are no tasks available. Please specify a recipe file to load." unless tool_output
        else
          all_tasks_length = tasks.length
          if options[:verbose].to_i < 1
            tasks = tasks.reject { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
          end

          tasks = tasks.sort_by { |task| task.fully_qualified_name }

          longest = tasks.map { |task| task.fully_qualified_name.length }.max
          max_length = output_columns - longest - LINE_PADDING
          max_length = MIN_MAX_LEN if max_length < MIN_MAX_LEN

          tasks.each do |task|
            if tool_output
              puts "rat #{task.fully_qualified_name}" # monkey patched
            else
              puts "rat %-#{longest}s # %s" % [task.fully_qualified_name, task.brief_description(max_length)]  # monkey patched
            end
          end

          unless tool_output
            if all_tasks_length > tasks.length
              puts
              puts "Some tasks were not listed, either because they have no description,"
              puts "or because they are only used internally by other tasks. To see all"
              puts "tasks, type `#{File.basename($0)} -vT'."
            end

            puts
            puts "Extended help may be available for these tasks."
            puts "Type `#{File.basename($0)} -e taskname' to view it."
          end
        end
      end

      def explain_task(config, name) #:nodoc:
        task = config.find_task(name)
        if task.nil?
          warn "The task `#{name}' does not exist."
        else
          puts "-" * HEADER_LEN
          puts "rat #{name}"  # monkey patched
          puts "-" * HEADER_LEN

          if task.description.empty?
            puts "There is no description for this task."
          else
            puts format_text(task.description)
          end

          puts
        end
      end

    end
  end
end
