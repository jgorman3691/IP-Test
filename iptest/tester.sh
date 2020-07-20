counting=$(eval cat /etc/iptest/bash_counter | wc -l);
echo "${counting}";
((counting++));
echo "${counting}";
