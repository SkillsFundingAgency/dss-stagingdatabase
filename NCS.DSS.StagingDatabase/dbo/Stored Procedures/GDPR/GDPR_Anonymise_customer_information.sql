CREATE PROCEDURE [dbo].[GDPR_Anonymise_customer_information]
AS
  BEGIN
      UPDATE [dss-customers]
      SET    Title = NULL,
             GivenName = NULL,
             FamilyName = NULL,
             IntroducedByAdditionalInfo = NULL,
             DateofBirth = Datetrunc(year, DateofBirth)
      WHERE  id IN (SELECT I.CustomerId
                    FROM   (SELECT CustomerId,
                                   Max(DateandTimeOfInteraction) AS
                                   LatestInteraction
                            FROM   [dss-interactions]
                            GROUP  BY CustomerId) I
                    WHERE  I.latestinteraction <= Dateadd(year, -6, Getdate()))
             AND DateOfRedaction IS NOT NULL

      UPDATE [dss-contacts]
      SET    MobileNumber = NULL,
             AlternativeNumber = NULL,
             HomeNumber = NULL,
             EmailAddress = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-addresses]
      SET    Address1 = NULL,
             Address2 = NULL,
             Address3 = NULL,
             Address4 = NULL,
             Address5 = NULL,
             PostCode = LEFT(PostCode, Len(PostCode) - 3),
             alternativepostcode = LEFT(AlternativePostCode,
                                   Len(AlternativePostCode) - 3)
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-employmentprogressions]
      SET    EmployerName = NULL,
             EmployerAddress = NULL,
             EmployerPostcode = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-actions]
      SET    ActionSummary = NULL,
             SignpostedTo = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-goals]
      SET    GoalSummary = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-actionplans]
      SET    CurrentSituation = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-webchats]
      SET    WebChatNarrative = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-customers-history]
      SET    Title = NULL,
             GivenName = NULL,
             FamilyName = NULL,
             IntroducedByAdditionalInfo = NULL,
             DateofBirth = Datetrunc(year, dateofbirth)
      WHERE  id IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-contacts-history]
      SET    MobileNumber = NULL,
             AlternativeNumber = NULL,
             HomeNumber = NULL,
             EmailAddress = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-addresses-history]
      SET    Address1 = NULL,
             Address2 = NULL,
             Address3 = NULL,
             Address4 = NULL,
             Address5 = NULL,
             PostCode = LEFT(PostCode, Len(PostCode) - 3),
             AlternativePostCode = LEFT(AlternativePostCode,
                                   Len(AlternativePostCode) - 3)
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-employmentprogressions-history]
      SET    EmployerName = NULL,
             EmployerAddress = NULL,
             EmployerPostcode = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-actions-history]
      SET    ActionSummary = NULL,
             SignpostedTo = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-goals-history]
      SET    GoalSummary = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-actionplans-history]
      SET    CurrentSituation = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )

      UPDATE [dss-webchats-history]
      SET    WebChatNarrative = NULL
      WHERE  CustomerId IN (SELECT I.CustomerId
                            FROM   (SELECT CustomerId,
                                           Max(DateandTimeOfInteraction) AS
                                           LatestInteraction
                                    FROM   [dss-interactions]
                                    GROUP  BY CustomerId) I
                            WHERE  I.LatestInteraction <=
                                   Dateadd(year, -6, Getdate())
                           )
  END