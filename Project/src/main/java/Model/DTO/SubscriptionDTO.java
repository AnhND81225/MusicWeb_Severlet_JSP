package Model.DTO;

import javax.persistence.*;

@Entity
@Table(name = "tblSubscription")
public class SubscriptionDTO {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plan_id")
    private Integer planID;

    @Column(name = "name_subscription", nullable = false)
    private String nameSubscription;

    @Column(name = "price", nullable = false)
    private Integer price;

    @Column(name = "duration_in_days", nullable = false)
    private Integer durationDay;

    @Column(name = "description")
    private String description;

    @Column(name = "hidden")
    private Boolean hidden = false;

    public SubscriptionDTO() {}

    public SubscriptionDTO(String nameSubscription, Integer price, Integer durationDay, String description) {
        this.nameSubscription = nameSubscription;
        this.price = price;
        this.durationDay = durationDay;
        this.description = description;
    }

    public Integer getPlanID() {
        return planID;
    }

    public void setPlanID(Integer planID) {
        this.planID = planID;
    }

    public String getNameSubscription() {
        return nameSubscription;
    }

    public void setNameSubscription(String nameSubscription) {
        this.nameSubscription = nameSubscription;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Integer getDurationDay() {
        return durationDay;
    }

    public void setDurationDay(Integer durationDay) {
        this.durationDay = durationDay;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getHidden() {
        return hidden;
    }

    public void setHidden(Boolean hidden) {
        this.hidden = hidden;
    }

    
}
