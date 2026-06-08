package com.farmerassistant.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

import com.farmerassistant.dao.FarmerDAO;
import com.farmerassistant.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/image-upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ImageUploadServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        
        try {
            String applicationPath = request.getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
            
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            Part filePart = request.getPart("image");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadFilePath + File.separator + uniqueFileName;
            
            filePart.write(filePath);
            
            String cropName = request.getParameter("cropName");
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            String queryType = "Image";
            String language = request.getParameter("language");
            if (language == null || language.isEmpty()) {
                language = "English";
            }
            
            int queryId = farmerDAO.addQueryWithReturn(user.getId(), subject, message, queryType, language, UPLOAD_DIR + "/" + uniqueFileName);
            
            String diseaseName = detectDisease(cropName);
            String treatmentAdvice = getTreatmentAdvice(diseaseName);
            
            farmerDAO.addDiseaseDetection(queryId, cropName, diseaseName, 85.0, treatmentAdvice);
            
            response.sendRedirect(request.getContextPath() + "/queries");
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/queries.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "Upload error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/queries.jsp").forward(request, response);
        }
    }
    
    private String detectDisease(String cropName) {
        if (cropName == null) return "Unknown disease";
        
        switch (cropName.toLowerCase()) {
            case "tomato":
                return "Early Blight";
            case "rice":
                return "Blast Disease";
            case "wheat":
                return "Rust Disease";
            case "cotton":
                return "Bollworm";
            default:
                return "Fungal Infection";
        }
    }
    
    private String getTreatmentAdvice(String diseaseName) {
        switch (diseaseName) {
            case "Early Blight":
                return "Remove affected leaves, apply fungicide containing chlorothalonil or copper. Improve air circulation and avoid overhead watering.";
            case "Blast Disease":
                return "Use resistant varieties, apply fungicides like tricyclazole. Maintain proper water management and avoid excessive nitrogen.";
            case "Rust Disease":
                return "Apply fungicides containing propiconazole or tebuconazole. Remove infected plant debris and practice crop rotation.";
            case "Bollworm":
                return "Use pheromone traps, apply appropriate insecticides. Install bird perches to encourage natural predators.";
            default:
                return "Consult local agriculture expert for specific treatment recommendations.";
        }
    }

   
}
