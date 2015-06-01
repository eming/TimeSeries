package com.company;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Locale;

public class Main {

    public static void main(String[] args){
        File fin1 = new File("D:\\books\\TUM\\thesis\\siemens\\DataEmin\\Circuit_Data_Summer_2011_prepared.txt");
        try {
            BufferedReader br = new BufferedReader(new FileReader(fin1));
            String line;
            int i = 0;
            String prev = null;
            while ((line = br.readLine()) != null) {
                i++;
                if (i < 2692 && i > 2686){
                    System.out.println(line + " --- " + i);
                }
                if (i == 2692){
                    break;
                }
                /*String[] tokens = line.split(",");
                int eMeterId = Integer.parseInt(tokens[0]);
                DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);
                Date date = format.parse(tokens[1]);
                double supplyAmount = Double.parseDouble(tokens[2]);
                EMeterData eMeterData = new EMeterData(eMeterId, date, supplyAmount);
                Date beginning = new Date(2011 - 1900, 5, 1);
                if (eMeterData.date.before(beginning)){
                    System.out.println(eMeterData + " -- " + EMeterData.formatter.format(beginning));
                    i++;
                }
                if (tokens[1].equals("2011-06-29 00:15")){
                    System.out.println(prev);
                }
                prev = line;*/
            }
            System.out.println(i);
        }catch (Exception ex){
            ex.printStackTrace();
        }
        if (true)return;

        ArrayList<EMeterData> eMeterDataList = new ArrayList<EMeterData>();
        File fin = new File("D:\\books\\TUM\\thesis\\siemens\\DataEmin\\Circuit_Data_Summer_2011.txt");
        try {
            BufferedReader br = new BufferedReader(new FileReader(fin));
            String line;
            while ((line = br.readLine()) != null) {
                String[] tokens = line.split(",");
                int eMeterId = Integer.parseInt(tokens[0]);
                DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);
                Date date = format.parse(tokens[1]);
                double supplyAmount = Double.parseDouble(tokens[2]);
                EMeterData eMeterData = new EMeterData(eMeterId, date, supplyAmount);
                eMeterDataList.add(eMeterData);
            }
            System.out.println("READ");
            Collections.sort(eMeterDataList);
            System.out.println("SORTED");
            File fout = new File("D:\\books\\TUM\\thesis\\siemens\\DataEmin\\Circuit_Data_Summer_2011_prepared.txt");
            FileOutputStream fos = new FileOutputStream(fout);
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));
            for (EMeterData eMeterData: eMeterDataList){
                if (eMeterData.eMeterId > 0 && eMeterData.date != null) {
                    bw.write(eMeterData.toString());
                    bw.newLine();
                }else {
                    System.out.println(eMeterData);
                }
            }
            bw.close();
            fos.close();
            System.out.println("WRITTEN");
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }
}
