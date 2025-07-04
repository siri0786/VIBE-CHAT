package com.app;

public class User {
    private String username;
    private String password;
    private String photo;

    public User(String username, String password, String photo) {
        this.username = username;
        this.password = password;
        this.photo = photo;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getPhoto() {
        return photo;
    }
}
