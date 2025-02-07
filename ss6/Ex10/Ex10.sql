USE ex9;
SELECT 
a.AppointmentID,
p.FullName AS PatientName,
d.FullName AS DoctorName,
a.AppointmentDate,
a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate ASC;

UPDATE appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
SET a.Status = 'Dang cho'
WHERE p.FullName = 'Nguyen Van An'
AND d.FullName = 'Phan Huong'
AND a.AppointmentDate >= NOW();

SELECT 
a.AppointmentID,
p.FullName AS PatientName,
d.FullName AS DoctorName,
a.AppointmentDate,
a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate ASC;

SELECT 
    p.FullName AS PatientName,
    d.FullName AS DoctorName,
    a.AppointmentDate,
    m.Diagnosis
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
JOIN medicalrecords m ON a.PatientID = m.PatientID AND a.DoctorID = m.DoctorID
WHERE a.PatientID IN (
    SELECT PatientID 
    FROM appointments 
    GROUP BY PatientID, DoctorID 
    HAVING COUNT(*) >= 2
);


SELECT 
    p.FullName AS PatientName,
    d.FullName AS DoctorName,
    a.AppointmentDate,
    m.Diagnosis
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
WHERE (p.PatientID, d.DoctorID) IN (
    SELECT PatientID, DoctorID
    FROM appointments
    GROUP BY PatientID, DoctorID
    HAVING COUNT(AppointmentID) >= 2
)
ORDER BY p.FullName, d.FullName, a.AppointmentDate;

SELECT 
    UPPER(CONCAT('BỆNH NHÂN: ', p.FullName, ' - BÁC SĨ: ', d.FullName)) AS AppointmentInfo,
    a.AppointmentDate,
    m.Diagnosis,
    a.Status
FROM appointments a
JOIN patients p ON a.PatientID = p.PatientID
JOIN doctors d ON a.DoctorID = d.DoctorID
LEFT JOIN medicalrecords m ON a.PatientID = m.PatientID AND a.DoctorID = m.DoctorID
ORDER BY a.AppointmentDate ASC;




