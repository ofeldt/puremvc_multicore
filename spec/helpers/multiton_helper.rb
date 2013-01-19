module PureMVC
  module MultiCore

    # shared context to reset those pesky singletons
    shared_context "singleton reset" do
      before :each do
        # Resetting the instance map is neccessary for testing Multiton behaviour
        subject.send(:class_variable_set, :@@instance_map, {})

        if subject == Facade
           Controller.send(:class_variable_set, :@@instance_map, {})
           Model.send(:class_variable_set, :@@instance_map, {})
           View.send(:class_variable_set, :@@instance_map, {})
        end
      end
    end

    # common behavior for all PureMVC-Multitons (MVC + Facade)
    shared_examples "any multiton" do

      # Gives us a demodulized class name at include-time
      def self.subject_name
        subject.call.to_s.gsub(/.*::/,"")
      end
      
      # Gives us a demodulized class name at run-time
      def subject_name
        subject.to_s.gsub(/.*::/,"")
      end

      it "should create a #{subject_name} with multiton-key" do
        subject.instance(:key).should be_kind_of(subject)
      end

      it "should return a #{subject_name} instance by multiton-key" do
        created_subject = subject.new(:key)
        found_subject = subject.instance(created_subject.multiton_key)

        created_subject.multiton_key.should equal(found_subject.multiton_key)
      end

      it "should require a multiton-key to be a Symbol" do
        lambda {
          subject.new(:symbol_key)
        }.should_not raise_error(Error::MultitonKeyError, 'Multiton key must be a Symbol!')

        lambda {
          subject.new(nil)
        }.should raise_error(Error::MultitonKeyError, 'Multiton key must be a Symbol!')
      end

      it "should require multiton-key to be unique" do
        subject.new(:unique_key)

        lambda {
          subject.new(:unique_key)
        }.should raise_error(Error::MultitonKeyError, /.*? instance for this Multiton key already constructed!/)
      end
    end

    # common behavior for PureMVC Controller, Model, View Actor multitons
    shared_examples "any core actor multiton" do

      def subject_name
        subject.to_s.gsub(/.*::/,"")
      end

      def self.subject_name
        subject.to_s.gsub(/.*::/,"")
      end

      it "should remove a #{subject_name} instance by multiton-key" do
        created_subject = subject.new(:key)
        subject.method("remove_#{subject_name.downcase}").call(:key)

        subject.instance(:key).should_not equal(created_subject)
      end
    end

  end
end
