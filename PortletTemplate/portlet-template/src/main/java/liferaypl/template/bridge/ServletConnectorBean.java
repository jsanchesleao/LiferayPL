package liferaypl.template.bridge;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;

public class ServletConnectorBean implements ServletConnector{
	
	public String getServlet(String servletUrl) {
		StringBuffer buffer = new StringBuffer();
		URL url;
		try {
			url = new URL(servletUrl);
			URLConnection conn = url.openConnection();
			conn.setDoOutput(true);
			BufferedWriter out = new BufferedWriter( new OutputStreamWriter( conn.getOutputStream() ) );
			out.write(""); //parameters
			out.flush();
			out.close();
			
			BufferedReader in = new BufferedReader( new InputStreamReader( conn.getInputStream()  ) );
			String response;
			while( (response = in.readLine()) != null  ){
				buffer.append(response);
			}
			in.close();
			
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return buffer.toString();
	}

}