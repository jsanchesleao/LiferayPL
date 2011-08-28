package liferaypl.template.actions;

import liferaypl.template.bridge.ServletConnector;

import org.springframework.beans.factory.annotation.Autowired;

import com.opensymphony.xwork2.ActionSupport;

public class BeginAction {
	
	private String data;
	
	@Autowired
	private ServletConnector servletConnector;
	public void setServletConnector(ServletConnector servletConnector){
		this.servletConnector = servletConnector;
	}

	public String execute(){
		this.data = servletConnector.getServlet("http://localhost:8080/portlet-template-1.0/cgi-bin/index.pl");
		return ActionSupport.SUCCESS;
	}
	
	public String getData(){
		return this.data;
	}
	
}
