## Jenkins CI Server
package { "java-1.6.0-openjdk":
	ensure => installed
}

class jenkins4php {
	include jenkins4php::plugins
	include jenkins4php::templatejob

	Class['jenkins4php::plugins'] -> Class['jenkins4php::templatejob']
}

class jenkins4php::plugins inherits jenkins {
    # Jenkins plugins
    install-jenkins-plugin {
    	"git-plugin" :
    		name => "git";
    }
    
    install-jenkins-plugin {
    	"checkstyle" :
    		name => "checkstyle";
    }
    
    install-jenkins-plugin {
    	"cobertura" :
    		name => "cobertura";
    }
    
    install-jenkins-plugin {
        "cloverphp" :
            name => "cloverphp";
    }
    
    install-jenkins-plugin {
        "dry" :
            name => "dry";
    }
    
    install-jenkins-plugin {
        "htmlpublisher" :
            name => "htmlpublisher";
    }
    
    install-jenkins-plugin {
        "jdepend" :
            name => "jdepend";
    }
    
    install-jenkins-plugin {
        "plot" :
            name => "plot";
    }
    
    install-jenkins-plugin {
        "pmd" :
            name => "pmd";
    }
    
    install-jenkins-plugin {
        "violations" :
            name => "violations";
    }
    
    install-jenkins-plugin {
        "xunit" :
            name => "xunit";
    }
}

class jenkins4php::templatejob {
	$jenkins_dir = '/var/lib/jenkins'
	File {
		owner => "jenkins",
		group => "jenkins",
		ensure => directory
	}
	file { "${jenkins_dir}/jobs": }
	file { "${jenkins_dir}/jobs/php-template": }
	file { "${jenkins_dir}/jobs/php-template/config.xml":
		source => "/vagrant/files/php-template/config.xml"
	}
	file { "${jenkins_dir}/jobs/php-template/LICENSE":
		source => "/vagrant/files/php-template/LICENSE"
	}
	exec {
		"java -jar jenkins-cli.jar -s http://localhost:8080 reload-configuration":
		path => "/usr/bin",
		cwd => "${jenkins_dir}/war/WEB-INF",
		require => File["${jenkins_dir}/jobs/php-template/config.xml"]
	}
}

include phpqatools
include jenkins4php

Class["phpqatools"] -> Package["java-1.6.0-openjdk"] -> Class["jenkins4php"]