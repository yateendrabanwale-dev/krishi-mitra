package com.farmerassistant.model;

public class ExpertReply {
    private final int id;
    private final int queryId;
    private final int expertId;
    private final String replyText;
    private final String replyDate;

    public ExpertReply(int id, int queryId, int expertId, String replyText, String replyDate) {
        this.id = id;
        this.queryId = queryId;
        this.expertId = expertId;
        this.replyText = replyText;
        this.replyDate = replyDate;
    }

    public int getId() { return id; }
    public int getQueryId() { return queryId; }
    public int getExpertId() { return expertId; }
    public String getReplyText() { return replyText; }
    public String getReplyDate() { return replyDate; }
}
