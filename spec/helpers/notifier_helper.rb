module PureMVC
  module MultiCore
    # common behavior for all PureMVC-Multitons (MVC + Facade)
    shared_examples "any notifier" do

      # Gives us a demodulized class name at include-time
      def self.subject_name
        subject.call.to_s.gsub(/.*::/,"")
      end

      # Gives us a demodulized class name at run-time
      def subject_name
        subject.to_s.gsub(/.*::/,"")
      end

      before(:each) do
        @facade = Facade.instance(:notifier_test)
      end

      it "should be bindable to a facade after creation" do
        lambda {
          subject.initialize_notifier(nil)
        }.should raise_error(Error::MultitonKeyError, 'Multiton key must be a Symbol!')
        lambda {
          subject.initialize_notifier(:notifier_test)
        }.should_not raise_error
      end

      it "should delegate notification sends to the facade" do
        @facade.should_receive(:send_notification).once
        lambda {
          subject.send_notification(:notification_name, :body, :type)
        }.should raise_error(Error::MultitonKeyError, 'Multiton key for this Notifier not yet initialized!')

        subject.initialize_notifier(:notifier_test)

        lambda {
          subject.send_notification(:notification_name, :body, :type)
        }.should_not raise_error
      end

      it "should provide a facade-reference" do
        lambda {
          subject.facade
        }.should raise_error(Error::MultitonKeyError, 'Multiton key for this Notifier not yet initialized!')

        subject.initialize_notifier(:notifier_test)

        subject.facade.should equal(@facade)
      end

    end
  end
end
