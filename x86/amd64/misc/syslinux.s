;--------------------------------------Macros---------------------------------------;

; Check syscall's return value at jump
%macro ScRetCheck	1
	cmp	rax, qword 0xFFFFFFFFFFFFF000
	ja	%1				; Jump to Error Handling Routine for the task. Do corScRetCheck at destination to re>
%endmacro

; Syscall shortcuts - Use your own judgement when other methods are faster to load arguments
%macro FullSyscall.1	2
	%ifnidni %2,xx
		mov	rdi, %2
	%endif
	mov	eax, %1
	syscall
%endmacro

%macro FullSyscall.2	3
	%ifnidni %3,xx
		mov	rsi, %3
	%endif
	%ifnidni %2,xx
		mov	rdi, %2
	%endif
	mov	eax, %1
	syscall
%endmacro

%macro FullSyscall.3	4
	%ifnidni %4,xx
		mov	rdx, %4
	%endif
	%ifnidni %3,xx
		mov	rsi, %3
	%endif
	%ifnidni %2,xx
		mov	rdi, %2
	%endif
	mov	eax, %1
	syscall
%endmacro

;-------------------------------------Structures-------------------------------------;

struc sockaddr
	.sa_family	resd 1
	.sa_data	resb 26
endstruc

struc sockaddr_in
	.sa_family	resd 1
	.sin_port	resw 1
	.sin_addr	resd 1
	.sin_padding	resb 8
endstruc

;-------------------------------------Constants-------------------------------------;

;--From <fcntl.h>--;

%define O_ACCMODE	00000003
%define O_RDONLY	00000000
%define O_WRONLY	00000001
%define O_RDWR		00000002
%define O_CREAT		00000100
%define O_EXCL		00000200
%define O_NOCTTY	00000400
%define O_TRUNC		00001000
%define O_APPEND	00002000
%define O_NONBLOCK	00004000
%define O_DSYNC		00010000
%define FASYNC		00020000
%define O_DIRECT	00040000
%define O_LARGEFILE	00100000
%define O_DIRECTORY	00200000
%define O_NOFOLLOW	00400000
%define O_NOATIME	01000000
%define O_CLOEXEC	02000000

;--From <stat.h>--;

%define S_IRWXU	 00700
%define S_IRUSR	 00400
%define S_IWUSR	 00200
%define S_IXUSR	 00100
%define S_IRWXG	 00070
%define S_IRGRP	 00040
%define S_IWGRP	 00020
%define S_IXGRP	 00010
%define S_IRWXO	 00007
%define S_IROTH	 00004
%define S_IWOTH	 00002
%define S_IXOTH	 00001

;--From <errno.h> and <errno-base.h>--;
%define EPERM		-1
%define ENOENT		-2
%define ESRCH		-3
%define EINTR		-4
%define EIO		-5
%define ENXIO		-6
%define E2BIG		-7
%define ENOEXEC		-8
%define EBADF		-9
%define ECHILD		-10
%define EAGAIN		-11
%define ENOMEM		-12
%define EACCES		-13
%define EFAULT		-14
%define ENOTBLK		-15
%define EBUSY		-16
%define EEXIST		-17
%define EXDEV		-18
%define ENODEV		-19
%define ENOTDIR		-20
%define EISDIR		-21
%define EINVAL		-22
%define ENFILE		-23
%define EMFILE		-24
%define ENOTTY		-25
%define ETXTBSY		-26
%define EFBIG		-27
%define ENOSPC		-28
%define ESPIPE		-29
%define EROFS		-30
%define EMLINK		-31
%define EPIPE		-32
%define EDOM		-33
%define ERANGE		-34
%define EDEADLK		-35
%define ENAMETOOLONG	-36
%define ENOLCK		-37
%define ENOSYS		-38
%define ENOTEMPTY	-39
%define ELOOP		-40
%define EWOULDBLOCK	EAGAIN
%define ENOMSG		-42
%define EIDRM		-43
%define ECHRNG		-44
%define EL2NSYNC	-45
%define EL3HLT		-46
%define EL3RST		-47
%define ELNRNG		-48
%define EUNATCH		-49
%define ENOCSI		-50
%define EL2HLT		-51
%define EBADE		-52
%define EBADR		-53
%define EXFULL		-54
%define ENOANO		-55
%define EBADRQC		-56
%define EBADSLT		-57
%define EDEADLOCK	EDEADLK
%define EBFONT		-59
%define ENOSTR		-60
%define ENODATA		-61
%define ETIME		-62
%define ENOSR		-63
%define ENONET		-64
%define ENOPKG		-65
%define EREMOTE		-66
%define ENOLINK		-67
%define EADV		-68
%define ESRMNT		-69
%define ECOMM		-70
%define EPROTO		-71
%define EMULTIHOP	-72
%define EDOTDOT		-73
%define EBADMSG		-74
%define EOVERFLOW	-75
%define ENOTUNIQ	-76
%define EBADFD		-77
%define EREMCHG		-78
%define ELIBACC		-79
%define ELIBBAD		-80
%define ELIBSCN		-81
%define ELIBMAX		-82
%define ELIBEXEC	-83
%define EILSEQ		-84
%define ERESTART	-85
%define ESTRPIPE	-86
%define EUSERS		-87
%define ENOTSOCK	-88
%define EDESTADDRREQ	-89
%define EMSGSIZE	-90
%define EPROTOTYPE	-91
%define ENOPROTOOPT	-92
%define EPROTONOSUPPORT	-93
%define ESOCKTNOSUPPORT	-94
%define EOPNOTSUPP	-95
%define EPFNOSUPPORT	-96
%define EAFNOSUPPORT	-97
%define EADDRINUSE	-98
%define EADDRNOTAVAIL	-99
%define ENETDOWN	-100
%define ENETUNREACH	-101
%define ENETRESET	-102
%define ECONNABORTED	-103
%define ECONNRESET	-104
%define ENOBUFS		-105
%define EISCONN		-106
%define ENOTCONN	-107
%define ESHUTDOWN	-108
%define ETOOMANYREFS	-109
%define ETIMEDOUT	-110
%define ECONNREFUSED	-111
%define EHOSTDOWN	-112
%define EHOSTUNREACH	-113
%define EALREADY	-114
%define EINPROGRESS	-115
%define ESTALE		-116
%define EUCLEAN		-117
%define ENOTNAM		-118
%define ENAVAIL		-119
%define EISNAM		-120
%define EREMOTEIO	-121
%define EDQUOT		-122
%define ENOMEDIUM	-123
%define EMEDIUMTYPE	-124
%define ECANCELED	-125
%define ENOKEY		-126
%define EKEYEXPIRED	-127
%define EKEYREVOKED	-128
%define EKEYREJECTED	-129
%define EOWNERDEAD	-130
%define ENOTRECOVERABLE	-131
%define ERFKILL		-132
%define EHWPOISON	-133

%define ERROR_MIN	-4095

;--From <socket.h>--;
%define AF_UNSPEC	0
%define AF_UNIX		1	; Unix domain sockets
%define AF_LOCAL	1	; POSIX name for AF_UNIX
%define AF_INET		2	; Internet IP Protocol
%define AF_AX25		3	; Amateur Radio AX.25
%define AF_IPX		4	; Novell IPX
%define AF_APPLETALK	5	; AppleTalk DDP
%define AF_NETROM	6	; Amateur Radio NET/ROM
%define AF_BRIDGE	7	; Multiprotocol bridge
%define AF_ATMPVC	8	; ATM PVCs
%define AF_X25		9	; Reserved for X.25 project
%define AF_INET6	10	; IP version 6
%define AF_ROSE		11	; Amateur Radio X.25 PLP
%define AF_DECNET	12	; Reserved for DECnet project
%define AF_NETBEUI	13	; Reserved for 802.2LLC project
%define AF_SECURITY	14	; Security callback pseudo AF
%define AF_KEY		15      ; PF_KEY key management API
%define AF_NETLINK	16
%define AF_ROUTE	AF_NETLINK ; Alias to emulate 4.4BSD
%define AF_PACKET	17	; Packet family
%define AF_ASH		18	; Ash
%define AF_ECONET	19	; Acorn Econet
%define AF_ATMSVC	20	; ATM SVCs
%define AF_RDS		21	; RDS sockets
%define AF_SNA		22	; Linux SNA Project (nutters!)
%define AF_IRDA		23	; IRDA sockets
%define AF_PPPOX	24	; PPPoX sockets
%define AF_WANPIPE	25	; Wanpipe API Sockets
%define AF_LLC		26	; Linux LLC
%define AF_IB		27	; Native InfiniBand address
%define AF_MPLS		28	; MPLS
%define AF_CAN		29	; Controller Area Network
%define AF_TIPC		30	; TIPC sockets
%define AF_BLUETOOTH	31	; Bluetooth sockets
%define AF_IUCV		32	; IUCV sockets
%define AF_RXRPC	33	; RxRPC sockets
%define AF_ISDN		34	; mISDN sockets
%define AF_PHONET	35	; Phonet sockets
%define AF_IEEE802154	36	; IEEE802154 sockets
%define AF_CAIF		37	; CAIF sockets
%define AF_ALG		38	; Algorithm sockets
%define AF_NFC		39	; NFC sockets
%define AF_VSOCK	40	; vSockets
%define AF_KCM		41	; Kernel Connection Multiplexor
%define AF_QIPCRTR	42	; Qualcomm IPC Router
%define AF_SMC		43	; smc sockets: reserve number for PF_SMC protocol family that reuses AF_INET address family
%define AF_XDP		44	; XDP sockets
%define AF_MCTP		45	; Management component transport protocol

%define AF_MAX		46	; For now..

%define PF_UNSPEC	AF_UNSPEC
%define PF_UNIX		AF_UNIX
%define PF_LOCAL	AF_LOCAL
%define PF_INET		AF_INET
%define PF_AX25		AF_AX25
%define PF_IPX		AF_IPX
%define PF_APPLETALK	AF_APPLETALK
%define	PF_NETROM	AF_NETROM
%define PF_BRIDGE	AF_BRIDGE
%define PF_ATMPVC	AF_ATMPVC
%define PF_X25		AF_X25
%define PF_INET6	AF_INET6
%define PF_ROSE		AF_ROSE
%define PF_DECNET	AF_DECNET
%define PF_NETBEUI	AF_NETBEUI
%define PF_SECURITY	AF_SECURITY
%define PF_KEY		AF_KEY
%define PF_NETLINK	AF_NETLINK
%define PF_ROUTE	AF_ROUTE
%define PF_PACKET	AF_PACKET
%define PF_ASH		AF_ASH
%define PF_ECONET	AF_ECONET
%define PF_ATMSVC	AF_ATMSVC
%define PF_RDS		AF_RDS
%define PF_SNA		AF_SNA
%define PF_IRDA		AF_IRDA
%define PF_PPPOX	AF_PPPOX
%define PF_WANPIPE	AF_WANPIPE
%define PF_LLC		AF_LLC
%define PF_IB		AF_IB
%define PF_MPLS		AF_MPLS
%define PF_CAN		AF_CAN
%define PF_TIPC		AF_TIPC
%define PF_BLUETOOTH	AF_BLUETOOTH
%define PF_IUCV		AF_IUCV
%define PF_RXRPC	AF_RXRPC
%define PF_ISDN		AF_ISDN
%define PF_PHONET	AF_PHONET
%define PF_IEEE802154	AF_IEEE802154
%define PF_CAIF		AF_CAIF
%define PF_ALG		AF_ALG
%define PF_NFC		AF_NFC
%define PF_VSOCK	AF_VSOCK
%define PF_KCM		AF_KCM
%define PF_QIPCRTR	AF_QIPCRTR
%define PF_SMC		AF_SMC
%define PF_XDP		AF_XDP
%define PF_MCTP		AF_MCTP
%define PF_MAX		AF_MAX

%define SOCK_STREAM     1
%define SOCK_DGRAM      2
%define SOCK_RAW        3
%define SOCK_RDM        4
%define SOCK_SEQPACKET  5
%define SOCK_DCCP       6
%define SOCK_PACKET     10

%define SOL_SOCKET	1

%define SO_DEBUG	1
%define SO_REUSEADDR	2
%define SO_TYPE		3
%define SO_ERROR	4
%define SO_DONTROUTE	5
%define SO_BROADCAST	6
%define SO_SNDBUF	7
%define SO_RCVBUF	8
%define SO_SNDBUFFORCE	32
%define SO_RCVBUFFORCE	33
%define SO_KEEPALIVE	9
%define SO_OOBINLINE	10
%define SO_NO_CHECK	11
%define SO_PRIORITY	12
%define SO_LINGER	13
%define SO_BSDCOMPAT	14
%define SO_REUSEPORT	15
%define SO_PASSCRED	16
%define SO_PEERCRED	17
%define SO_RCVLOWAT	18
%define SO_SNDLOWAT	19
%define SO_RCVTIMEO_OLD	20
%define SO_SNDTIMEO_OLD	21
%define SO_SECURITY_AUTHENTICATION		22
%define SO_SECURITY_ENCRYPTION_TRANSPORT	23
%define SO_SECURITY_ENCRYPTION_NETWORK		24
%define SO_BINDTODEVICE	25
%define SO_ATTACH_FILTER	26
%define SO_DETACH_FILTER	27
%define SO_GET_FILTER		SO_ATTACH_FILTER
%define SO_PEERNAME		28
%define SO_ACCEPTCONN		30
%define SO_PEERSEC		31
%define SO_PASSSEC		34
%define SO_MARK			36
%define SO_PROTOCOL		38
%define SO_DOMAIN		39
%define SO_RXQ_OVFL             40
%define SO_WIFI_STATUS		41
%define SCM_WIFI_STATUS	SO_WIFI_STATUS
%define SO_PEEK_OFF		42
%define SO_NOFCS		43
%define SO_LOCK_FILTER		44
%define SO_SELECT_ERR_QUEUE	45
%define SO_BUSY_POLL		46
%define SO_MAX_PACING_RATE	47
%define SO_BPF_EXTENSIONS	48
%define SO_INCOMING_CPU		49
%define SO_ATTACH_BPF		50
%define SO_DETACH_BPF		SO_DETACH_FILTER
%define SO_ATTACH_REUSEPORT_CBPF	51
%define SO_ATTACH_REUSEPORT_EBPF	52
%define SO_CNX_ADVICE		53
%define SCM_TIMESTAMPING_OPT_STATS	54
%define SO_MEMINFO		55
%define SO_INCOMING_NAPI_ID	56
%define SO_COOKIE		57
%define SCM_TIMESTAMPING_PKTINFO	58
%define SO_PEERGROUPS		59
%define SO_ZEROCOPY		60
%define SO_TXTIME		61
%define SCM_TXTIME		SO_TXTIME
%define SO_BINDTOIFINDEX	62
%define SO_TIMESTAMP_OLD        29
%define SO_TIMESTAMPNS_OLD      35
%define SO_TIMESTAMPING_OLD     37
%define SO_TIMESTAMP_NEW        63
%define SO_TIMESTAMPNS_NEW      64
%define SO_TIMESTAMPING_NEW     65
%define SO_RCVTIMEO_NEW         66
%define SO_SNDTIMEO_NEW         67
%define SO_DETACH_REUSEPORT_BPF 68
%define SO_PREFER_BUSY_POLL	69
%define SO_BUSY_POLL_BUDGET	70
%define SO_NETNS_COOKIE		71
%define SO_BUF_LOCK		72
%define SO_RESERVE_MEM		73
%define SO_TXREHASH		74
%define SO_RCVMARK		75
%define SO_PASSPIDFD		76
%define SO_PEERPIDFD		77

%define SO_TIMESTAMP		SO_TIMESTAMP_OLD
%define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
%define SO_TIMESTAMPING		SO_TIMESTAMPING_OLD

%define SO_RCVTIMEO		SO_RCVTIMEO_OLD
%define SO_SNDTIMEO		SO_SNDTIMEO_OLD

%define SCM_TIMESTAMP           SO_TIMESTAMP
%define SCM_TIMESTAMPNS         SO_TIMESTAMPNS
%define SCM_TIMESTAMPING        SO_TIMESTAMPING

;--SIGNALS--;
%define NSIG		32

%define SIGHUP		 1
%define SIGINT		 2
%define SIGQUIT		 3
%define SIGILL		 4
%define SIGTRAP		 5
%define SIGABRT		 6
%define SIGIOT		 6
%define SIGBUS		 7
%define SIGFPE		 8
%define SIGKILL		 9
%define SIGUSR1		10
%define SIGSEGV		11
%define SIGUSR2		12
%define SIGPIPE		13
%define SIGALRM		14
%define SIGTERM		15
%define SIGSTKFLT	16
%define SIGCHLD		17
%define SIGCONT		18
%define SIGSTOP		19
%define SIGTSTP		20
%define SIGTTIN		21
%define SIGTTOU		22
%define SIGURG		23
%define SIGXCPU		24
%define SIGXFSZ		25
%define SIGVTALRM	26
%define SIGPROF		27
%define SIGWINCH	28
%define SIGIO		29
%define SIGPOLL		SIGIO
; %define SIGLOST		29
%define SIGPWR		30
%define SIGSYS		31
%define	SIGUNUSED	31

;--Syscalls--;
%define sys_read	0
%define sys_write	1
%define sys_open	2
%define sys_close	3
%define sys_stat	4
%define sys_fstat	5
%define sys_lstat	6
%define sys_poll	7
%define sys_lseek	8
%define sys_mmap	9
%define sys_mprotect	10
%define sys_munmap	11
%define sys_brk	12
%define sys_rt_sigaction	13
%define sys_rt_sigprocmask	14
%define sys_rt_sigreturn	15
%define sys_ioctl	16
%define sys_pread64	17
%define sys_pwrite64	18
%define sys_readv	19
%define sys_writev	20
%define sys_access	21
%define sys_pipe	22
%define sys_select	23
%define sys_sched_yield	24
%define sys_mremap	25
%define sys_msync	26
%define sys_mincore	27
%define sys_madvise	28
%define sys_shmget	29
%define sys_shmat	30
%define sys_shmctl	31
%define sys_dup	32
%define sys_dup2	33
%define sys_pause	34
%define sys_nanosleep	35
%define sys_getitimer	36
%define sys_alarm	37
%define sys_setitimer	38
%define sys_getpid	39
%define sys_sendfile	40
%define sys_socket	41
%define sys_connect	42
%define sys_accept	43
%define sys_sendto	44
%define sys_recvfrom	45
%define sys_sendmsg	46
%define sys_recvmsg	47
%define sys_shutdown	48
%define sys_bind	49
%define sys_listen	50
%define sys_getsockname	51
%define sys_getpeername	52
%define sys_socketpair	53
%define sys_setsockopt	54
%define sys_getsockopt	55
%define sys_clone	56
%define sys_fork	57
%define sys_vfork	58
%define sys_execve	59
%define sys_exit	60
%define sys_wait4	61
%define sys_kill	62
%define sys_uname	63
%define sys_semget	64
%define sys_semop	65
%define sys_semctl	66
%define sys_shmdt	67
%define sys_msgget	68
%define sys_msgsnd	69
%define sys_msgrcv	70
%define sys_msgctl	71
%define sys_fcntl	72
%define sys_flock	73
%define sys_fsync	74
%define sys_fdatasync	75
%define sys_truncate	76
%define sys_ftruncate	77
%define sys_getdents	78
%define sys_getcwd	79
%define sys_chdir	80
%define sys_fchdir	81
%define sys_rename	82
%define sys_mkdir	83
%define sys_rmdir	84
%define sys_creat	85
%define sys_link	86
%define sys_unlink	87
%define sys_symlink	88
%define sys_readlink	89
%define sys_chmod	90
%define sys_fchmod	91
%define sys_chown	92
%define sys_fchown	93
%define sys_lchown	94
%define sys_umask	95
%define sys_gettimeofday	96
%define sys_getrlimit	97
%define sys_getrusage	98
%define sys_sysinfo	99
%define sys_times	100
%define sys_ptrace	101
%define sys_getuid	102
%define sys_syslog	103
%define sys_getgid	104
%define sys_setuid	105
%define sys_setgid	106
%define sys_geteuid	107
%define sys_getegid	108
%define sys_setpgid	109
%define sys_getppid	110
%define sys_getpgrp	111
%define sys_setsid	112
%define sys_setreuid	113
%define sys_setregid	114
%define sys_getgroups	115
%define sys_setgroups	116
%define sys_setresuid	117
%define sys_getresuid	118
%define sys_setresgid	119
%define sys_getresgid	120
%define sys_getpgid	121
%define sys_setfsuid	122
%define sys_setfsgid	123
%define sys_getsid	124
%define sys_capget	125
%define sys_capset	126
%define sys_rt_sigpending	127
%define sys_rt_sigtimedwait	128
%define sys_rt_sigqueueinfo	129
%define sys_rt_sigsuspend	130
%define sys_sigaltstack	131
%define sys_utime	132
%define sys_mknod	133
%define sys_uselib	134
%define sys_personality	135
%define sys_ustat	136
%define sys_statfs	137
%define sys_fstatfs	138
%define sys_sysfs	139
%define sys_getpriority	140
%define sys_setpriority	141
%define sys_sched_setparam	142
%define sys_sched_getparam	143
%define sys_sched_setscheduler	144
%define sys_sched_getscheduler	145
%define sys_sched_get_priority_max	146
%define sys_sched_get_priority_min	147
%define sys_sched_rr_get_interval	148
%define sys_mlock	149
%define sys_munlock	150
%define sys_mlockall	151
%define sys_munlockall	152
%define sys_vhangup	153
%define sys_modify_ldt	154
%define sys_pivot_root	155
%define sys__sysctl	156
%define sys_prctl	157
%define sys_arch_prctl	158
%define sys_adjtimex	159
%define sys_setrlimit	160
%define sys_chroot	161
%define sys_sync	162
%define sys_acct	163
%define sys_settimeofday	164
%define sys_mount	165
%define sys_umount2	166
%define sys_swapon	167
%define sys_swapoff	168
%define sys_reboot	169
%define sys_sethostname	170
%define sys_setdomainname	171
%define sys_iopl	172
%define sys_ioperm	173
%define sys_create_module	174
%define sys_init_module	175
%define sys_delete_module	176
%define sys_get_kernel_syms	177
%define sys_query_module	178
%define sys_quotactl	179
%define sys_nfsservctl	180
%define sys_getpmsg	181
%define sys_putpmsg	182
%define sys_afs_syscall	183
%define sys_tuxcall	184
%define sys_security	185
%define sys_gettid	186
%define sys_readahead	187
%define sys_setxattr	188
%define sys_lsetxattr	189
%define sys_fsetxattr	190
%define sys_getxattr	191
%define sys_lgetxattr	192
%define sys_fgetxattr	193
%define sys_listxattr	194
%define sys_llistxattr	195
%define sys_flistxattr	196
%define sys_removexattr	197
%define sys_lremovexattr	198
%define sys_fremovexattr	199
%define sys_tkill	200
%define sys_time	201
%define sys_futex	202
%define sys_sched_setaffinity	203
%define sys_sched_getaffinity	204
%define sys_set_thread_area	205
%define sys_io_setup	206
%define sys_io_destroy	207
%define sys_io_getevents	208
%define sys_io_submit	209
%define sys_io_cancel	210
%define sys_get_thread_area	211
%define sys_lookup_dcookie	212
%define sys_epoll_create	213
%define sys_epoll_ctl_old	214
%define sys_epoll_wait_old	215
%define sys_remap_file_pages	216
%define sys_getdents64	217
%define sys_set_tid_address	218
%define sys_restart_syscall	219
%define sys_semtimedop	220
%define sys_fadvise64	221
%define sys_timer_create	222
%define sys_timer_settime	223
%define sys_timer_gettime	224
%define sys_timer_getoverrun	225
%define sys_timer_delete	226
%define sys_clock_settime	227
%define sys_clock_gettime	228
%define sys_clock_getres	229
%define sys_clock_nanosleep	230
%define sys_exit_group	231
%define sys_epoll_wait	232
%define sys_epoll_ctl	233
%define sys_tgkill	234
%define sys_utimes	235
%define sys_vserver	236
%define sys_mbind	237
%define sys_set_mempolicy	238
%define sys_get_mempolicy	239
%define sys_mq_open	240
%define sys_mq_unlink	241
%define sys_mq_timedsend	242
%define sys_mq_timedreceive	243
%define sys_mq_notify	244
%define sys_mq_getsetattr	245
%define sys_kexec_load	246
%define sys_waitid	247
%define sys_add_key	248
%define sys_request_key	249
%define sys_keyctl	250
%define sys_ioprio_set	251
%define sys_ioprio_get	252
%define sys_inotify_init	253
%define sys_inotify_add_watch	254
%define sys_inotify_rm_watch	255
%define sys_migrate_pages	256
%define sys_openat	257
%define sys_mkdirat	258
%define sys_mknodat	259
%define sys_fchownat	260
%define sys_futimesat	261
%define sys_newfstatat	262
%define sys_unlinkat	263
%define sys_renameat	264
%define sys_linkat	265
%define sys_symlinkat	266
%define sys_readlinkat	267
%define sys_fchmodat	268
%define sys_faccessat	269
%define sys_pselect6	270
%define sys_ppoll	271
%define sys_unshare	272
%define sys_set_robust_list	273
%define sys_get_robust_list	274
%define sys_splice	275
%define sys_tee	276
%define sys_sync_file_range	277
%define sys_vmsplice	278
%define sys_move_pages	279
%define sys_utimensat	280
%define sys_epoll_pwait	281
%define sys_signalfd	282
%define sys_timerfd_create	283
%define sys_eventfd	284
%define sys_fallocate	285
%define sys_timerfd_settime	286
%define sys_timerfd_gettime	287
%define sys_accept4	288
%define sys_signalfd4	289
%define sys_eventfd2	290
%define sys_epoll_create1	291
%define sys_dup3	292
%define sys_pipe2	293
%define sys_inotify_init1	294
%define sys_preadv	295
%define sys_pwritev	296
%define sys_rt_tgsigqueueinfo	297
%define sys_perf_event_open	298
%define sys_recvmmsg	299
%define sys_fanotify_init	300
%define sys_fanotify_mark	301
%define sys_prlimit64	302
%define sys_name_to_handle_at	303
%define sys_open_by_handle_at	304
%define sys_clock_adjtime	305
%define sys_syncfs	306
%define sys_sendmmsg	307
%define sys_setns	308
%define sys_getcpu	309
%define sys_process_vm_readv	310
%define sys_process_vm_writev	311
%define sys_kcmp	312
%define sys_finit_module	313
%define sys_sched_setattr	314
%define sys_sched_getattr	315
%define sys_renameat2	316
%define sys_seccomp	317
%define sys_getrandom	318
%define sys_memfd_create	319
%define sys_kexec_file_load	320
%define sys_bpf	321
%define stub_execveat	322
%define userfaultfd	323
%define membarrier	324
%define mlock2	325
%define copy_file_range	326
%define preadv2	327
%define pwritev2	328
%define pkey_mprotect	329
%define pkey_alloc	330
%define pkey_free	331
%define statx	332
%define io_pgetevents	333
%define rseq	334
%define pkey_mprotect	335
