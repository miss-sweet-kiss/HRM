package dbc;

import java.io.ByteArrayOutputStream;
import java.io.DataOutput;
import java.io.DataOutputStream;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import logic.FR;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfDiv;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

/**
 * Servlet implementation class ExportPDF
 */
@WebServlet("/ExportPDF")
public class ExportPDF extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ExportPDF() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		FR_DAO fr_dao = (FR_DAO)request.getSession().getAttribute("FR_DAO");
		Integer idFR = Integer.parseInt(request.getParameter("fr"));
		
		String standart = new String();
		FR fr = new FR();
		
		try {
			standart = fr_dao.getCorporateStandartByFR(idFR);
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
			fr = fr_dao.getFRById(idFR);
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String frName = new String(fr.getName());
		String frGroup = new String(fr.getGroup());
		if(standart == null) {
			//out.println("<p style='color:Red'><b>Для данной функциональной обязанности стандарта нет</b></p>");
		} else {
		response.setContentType("application/pdf");
		Document document = new Document();
		response.setHeader("Content-Disposition","inline; filename=\"report.pdf\"");		

		try {
			Font font = new Font(BaseFont.createFont("c:/windows/fonts/times.ttf",BaseFont.IDENTITY_H,BaseFont.EMBEDDED));
			ByteArrayOutputStream buffer = new ByteArrayOutputStream();
			PdfWriter.getInstance(document, buffer);
			document.open();

			PdfDiv div = new PdfDiv();
			Chunk t = new Chunk(frGroup+" "+frName);
			Chunk t2 = new Chunk(standart);
			t.setFont(font);
			t2.setFont(font);
			div.addElement(t);
			div.addElement(t2);
					
			document.add(div);	
			
			document.close();

			DataOutput dataOutput = new DataOutputStream(response.getOutputStream());
			byte[] bytes = buffer.toByteArray();
			response.setContentLength(bytes.length);
			for (int i = 0; i < bytes.length; i++) {
				dataOutput.write(bytes[i]);
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
