# D796 Video Commands (Required Only)

This recording is my D796 performance assessment demonstration and aligns with the assignment requirements for sections A through G. The commands below are the required execution steps that match the scripts and outcomes documented in my written paper, and I will run them in order to show validation, user management, shell configuration, package operations, network checks, disk cleanup, and archive comparison.

```bash
# I am starting in the scripts directory and making all scripts executable.
cd /workspace/scripts
chmod +x *.sh

# Section A. I will run create_user.sh without arguments to show validation.
./create_user.sh
# Now I run create_user.sh with a valid username.
./create_user.sh studentdemo
# Now I switch to the new user and then return.
su - studentdemo
exit

# Section B. I will run delete_user.sh without arguments to show validation.
./delete_user.sh
# Now I run delete_user.sh with the same username and confirm deletion.
./delete_user.sh studentdemo
# I attempt to switch to the deleted user to confirm removal.
su - studentdemo

# Section C. I apply shell customization and reload bash settings.
./configure_shell_env.sh

source ~/.bashrc
# From a non-bin directory, I execute both scripts through PATH.
cd /tmp
create_user.sh studentpath
delete_user.sh studentpath

# Section D. I run the package scripts and verify update.log.
cd /workspace/scripts
./install_vim.sh
./update_packages.sh
ls -l update.log

# Section E. I run all three network scripts and show the flowchart file.
./check_google_domain.sh
./check_google_dns_ip.sh
./check_dns_resolution.sh
cat "../docs/network_flowchart.md"

# Sections F and G. I run disk cleanup, then archive comparison.
./disk_cleanup.sh
./archive_compare.sh
```