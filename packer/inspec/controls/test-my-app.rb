title 'Ensure app is properly installed and running'

    describe file('/etc/systemd/system/app.service') do
        it { should exist }
    end

    describe service('app') do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
    end

