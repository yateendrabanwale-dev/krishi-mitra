package com.farmerassistant.model;

public class FAQ {
    private final int id;
    private final String category;
    private final String question;
    private final String answer;
    private final String language;
    private final int views;

    public FAQ(int id, String category, String question, String answer, String language, int views) {
        this.id = id;
        this.category = category;
        this.question = question;
        this.answer = answer;
        this.language = language;
        this.views = views;
    }

    public int getId() { return id; }
    public String getCategory() { return category; }
    public String getQuestion() { return question; }
    public String getAnswer() { return answer; }
    public String getLanguage() { return language; }
    public int getViews() { return views; }
}
