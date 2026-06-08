<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "Query System"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .query-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    border-bottom: 1px solid #dce5d8;
    padding-bottom: 10px;
  }
  .query-tab {
    padding: 10px 20px;
    background: #e8f2e8;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 600;
    color: #215c34;
  }
  .query-tab.active {
    background: #2f7d46;
    color: white;
  }
  .query-content {
    display: none;
  }
  .query-content.active {
    display: block;
  }
  .form-stack label {
    display: block;
    margin-bottom: 12px;
  }
  .form-stack input,
  .form-stack select,
  .form-stack textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #dce5d8;
    border-radius: 4px;
    margin-top: 4px;
  }
  .form-stack textarea {
    min-height: 100px;
    resize: vertical;
  }
  .voice-controls {
    display: flex;
    gap: 10px;
    align-items: center;
    margin: 16px 0;
  }
  .voice-result {
    background: #f5f8ef;
    padding: 16px;
    border-radius: 8px;
    margin-top: 12px;
    min-height: 60px;
  }
  .expert-reply {
    background: #f0f7f0;
    border-left: 4px solid #2f7d46;
    padding: 16px;
    margin: 12px 0;
    border-radius: 4px;
  }
  .expert-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    font-weight: 600;
  }
  .badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
  }
  .badge-pending {
    background: #fff3cd;
    color: #856404;
  }
  .badge-answered {
    background: #d4edda;
    color: #155724;
  }
  .disease-result {
    background: #fff3cd;
    border: 1px solid #ffc107;
    padding: 16px;
    border-radius: 8px;
    margin-top: 12px;
  }
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Query System</h2>
      <p class="muted">Ask experts via text, voice, or image upload for disease detection</p>
    </div>
  </div>

  <div class="query-tabs">
    <button class="query-tab active" onclick="showQueryTab('text')">Text Query</button>
    <button class="query-tab" onclick="showQueryTab('voice')">Voice Query</button>
    <button class="query-tab" onclick="showQueryTab('image')">Image Upload</button>
  </div>

  <!-- Text Query -->
  <div id="text" class="query-content active">
    <form class="form-stack" method="post" action="${pageContext.request.contextPath}/queries">
      <input type="hidden" name="queryType" value="Text">
      <label>Subject
        <input type="text" name="subject" placeholder="Brief subject of your query" required>
      </label>
      <label>Language
        <select name="language">
          <option value="English">English</option>
          <option value="Hindi">Hindi</option>
          <option value="Marathi">Marathi</option>
        </select>
      </label>
      <label>Your Question
        <textarea name="message" placeholder="Type your farming question here..." required></textarea>
      </label>
      <button class="btn" type="submit">Submit Text Query</button>
    </form>
  </div>

  <!-- Voice Query -->
  <div id="voice" class="query-content">
    <form class="form-stack" method="post" action="${pageContext.request.contextPath}/queries">
      <input type="hidden" name="queryType" value="Voice">
      <label>Language
        <select name="language" id="voiceLanguage">
          <option value="Hindi">Hindi</option>
          <option value="Marathi">Marathi</option>
          <option value="English">English</option>
        </select>
      </label>
      <label>Subject
        <input type="text" name="subject" placeholder="Brief subject of your query" required>
      </label>
      <div class="voice-controls">
        <button type="button" id="startVoiceBtn" onclick="startVoiceRecording()">🎤 Start Recording</button>
        <button type="button" id="stopVoiceBtn" onclick="stopVoiceRecording()" style="display: none;">⏹ Stop Recording</button>
        <span id="recordingStatus" style="color: #666;"></span>
      </div>
      <label>Your Question (Voice Transcription)
        <textarea name="message" id="voiceTranscript" placeholder="Your voice will be transcribed here..." required></textarea>
      </label>
      <button class="btn" type="submit">Submit Voice Query</button>
    </form>
  </div>

  <!-- Image Upload for Disease Detection -->
  <div id="image" class="query-content">
    <form class="form-stack" method="post" action="${pageContext.request.contextPath}/image-upload" enctype="multipart/form-data">
      <label>Crop Name
        <select name="cropName" required>
          <option value="">Select crop</option>
          <option value="Tomato">Tomato</option>
          <option value="Rice">Rice</option>
          <option value="Wheat">Wheat</option>
          <option value="Cotton">Cotton</option>
          <option value="Maize">Maize</option>
          <option value="Onion">Onion</option>
        </select>
      </label>
      <label>Subject
        <input type="text" name="subject" placeholder="Brief subject of your query" required>
      </label>
      <label>Language
        <select name="language">
          <option value="English">English</option>
          <option value="Hindi">Hindi</option>
          <option value="Marathi">Marathi</option>
        </select>
      </label>
      <label>Upload Leaf Photo
        <input type="file" name="image" accept="image/*" required>
      </label>
      <label>Additional Details
        <textarea name="message" placeholder="Describe the issue or symptoms you observe..."></textarea>
      </label>
      <button class="btn" type="submit">Upload for Disease Detection</button>
    </form>
  </div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>My Queries & Expert Replies</h2>
      <p class="muted">Your submitted queries and expert responses</p>
    </div>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>Subject</th>
        <th>Type</th>
        <th>Status</th>
        <th>Disease Detected</th>
        <th>Date</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("rows");
        if (rows != null) {
          for (Map<String, Object> row : rows) {
            String status = (String) row.get("status");
            String badgeClass = status.equals("Answered") ? "badge-answered" : "badge-pending";
      %>
      <tr>
        <td><strong><%= row.get("subject") %></strong></td>
        <td><%= row.get("query_type") %></td>
        <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
        <td><%= row.get("detected_issue") != null ? row.get("detected_issue") : "-" %></td>
        <td><%= row.get("created_at") %></td>
      </tr>
      <% }} %>
      </tbody>
    </table>
  </div>
</section>

<script>
  let recognition = null;
  let isRecording = false;

  function showQueryTab(tabId) {
    document.querySelectorAll('.query-content').forEach(content => {
      content.classList.remove('active');
    });
    document.querySelectorAll('.query-tab').forEach(tab => {
      tab.classList.remove('active');
    });
    document.getElementById(tabId).classList.add('active');
    event.target.classList.add('active');
  }

  function startVoiceRecording() {
    if ('webkitSpeechRecognition' in window || 'SpeechRecognition' in window) {
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      recognition = new SpeechRecognition();
      
      const language = document.getElementById('voiceLanguage').value;
      recognition.lang = language === 'Hindi' ? 'hi-IN' : 
                        language === 'Marathi' ? 'mr-IN' : 'en-US';
      
      recognition.continuous = true;
      recognition.interimResults = true;
      
      recognition.onresult = function(event) {
        let transcript = '';
        for (let i = event.resultIndex; i < event.results.length; i++) {
          transcript += event.results[i][0].transcript;
        }
        document.getElementById('voiceTranscript').value = transcript;
      };
      
      recognition.onerror = function(event) {
        console.error('Voice recognition error:', event.error);
        stopVoiceRecording();
      };
      
      recognition.onend = function() {
        if (isRecording) {
          stopVoiceRecording();
        }
      };
      
      recognition.start();
      isRecording = true;
      document.getElementById('startVoiceBtn').style.display = 'none';
      document.getElementById('stopVoiceBtn').style.display = 'inline-block';
      document.getElementById('recordingStatus').textContent = '🔴 Recording...';
    } else {
      alert('Voice recognition not supported in this browser. Please use Chrome or Edge.');
    }
  }

  function stopVoiceRecording() {
    if (recognition) {
      recognition.stop();
    }
    isRecording = false;
    document.getElementById('startVoiceBtn').style.display = 'inline-block';
    document.getElementById('stopVoiceBtn').style.display = 'none';
    document.getElementById('recordingStatus').textContent = '✓ Recording stopped';
  }
</script>

<%@ include file="includes/footer.jspf" %>
